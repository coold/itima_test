class CommentsController < ApplicationController
	skip_before_filter :log, only: [:edit]
	def create
		@comment=Comment.new(params[:comment])
		@comment.user_id=current_user.id
		@comment.username=current_user.username
		respond_to do |format|
			if @comment.save
				format.html { redirect_to post_path(@comment.post), notice: 'Comment created' }
				format.js
			end
		end
	end

	def destroy
		@comment=Comment.find(params[:id])
		@current_post=@comment.post
		@comment.destroy
		respond_to do |format|
			format.html { redirect_to post_path(@current_post), notice: "Comment deleted"}
			format.js
		end
	end

	def edit
		@comment=Comment.find(params[:id])
	end

	def update
		@comment=Comment.find(params[:id])
		respond_to do |format|
			if @comment.update(params[:comment])
				format.html { redirect_to @comment.post, notice: 'Comment updated' }
			else
				format.html { render action: 'edit'}
			end
		end
	end

	private
	def current_resource
      @current_resource ||=Comment.find(params[:id]) if params[:id]
    end
end
