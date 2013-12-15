class Permission
	def initialize(current_user)
		allow :sessions, [:new, :create]
		allow :posts, [:index, :show]
		allow :users, [:new, :show, :create]
		allow_param :user, [:username, :email, :password, :password_confirmation]
		if current_user
			allow :sessions, :destroy
			allow_param :comment, [:body, :post_id]
			allow :comments, [:create]
			allow :comments, [:edit, :update, :destroy] do |comment|
				comment.user_id==current_user.id
			end
			allow :users, [:edit, :update, :destroy] do |user|
				user.id==current_user.id
			end
			allow :posts, [:new, :create]
			allow :posts, [:edit, :update, :destroy] do |post|
				post.user_id==current_user.id
			end
			allow_param :post, [:title, :body]
			if current_user.status=='moder'
				allow :posts, [:edit, :update, :destroy]
				allow :comments, [:edit, :update, :destroy]
			end
			allow_all if current_user.status=='admin'
		end
	end

	def allow_param(resources, attributes)
		@allowed_params ||={}
		Array(resources).each do |resource|
			@allowed_params[resource.to_s]||=[]
			@allowed_params[resource.to_s]+=Array(attributes).map(&:to_s)
		end
	end

	def allow_param?(resource,attribute)
		if @allow_all
			true
		elsif @allowed_actions && @allowed_params[resource.to_s]
			@allowed_params[resource.to_s].include? attribute.to_s
		end
	end
			


	def allow_all
		@allow_all=true
	end

	def allow(controllers, actions, &block)
		@allowed_actions||={}
		Array(controllers).each do |controller|
			Array(actions).each do |action|
				@allowed_actions[[controller.to_s,action.to_s]]= block || true
			end
		end
	end

	def allow?(controller, action, resource = nil)
		allowed = @allow_all || @allowed_actions[[controller.to_s,action.to_s]]
		allowed && (allowed==true || resource && allowed.call(resource))
	end

	def permit_params!(params)
		if @allow_all
			params.permit!
		elsif @allowed_params
			@allowed_params.each do |resource, attributes|
				if params[resource].respond_to? :permit
					params[resource]=params[resource].permit(*attributes)
				end
			end
		end
	end

end