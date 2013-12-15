class UsersController < ApplicationController
	skip_before_filter :log, only: [:show, :new,:index,:edit]

	def new
		@user=User.new
	end

	def new_user_by_admin
		@user=User.new
	end

	def index
		@users=User.all.order('created_at DESC')
	end

	def edit
		@user=User.find(params[:id])
	end

	def destroy
		@user=User.find(params[:id])
		if @user.destroy
		  redirect_to posts_path, notice: 'User was deleted'
		else
			render 'index'
		end
	end

	def update
		@user=User.find(params[:id])
		if @user.update(params[:user])
			redirect_to @user, notice: 'User was updated' 
		else
			render 'edit'
		end
	end

	def show
		@user=User.find_by_id(params[:id]) || false
	end

	def create
		@user=User.new(params[:user])
		if !@user.status
			@user.status='user'
		end
		if @user.save
			if !current_user
				cookies.permanent[:auth_token]=@user.auth_token
				redirect_to posts_path, notice: "Signed in!"
			elsif current_user.status=='admin'
				redirect_to users_path, notice: "User created"
			end
		else
			render 'new'
		end
	end

	private
	def current_resource
      @current_resource ||=User.find(params[:id]) if params[:id]
    end
end
