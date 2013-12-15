class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authorize
  before_filter :log

  delegate :allow?, to: :current_permission
  helper_method :allow?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?

  private

  def current_user
  	@current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def current_resource
    nil
  end

  def authorize
    if current_permission.allow?(params[:controller], params[:action], current_resource)
      current_permission.permit_params! params
    else
      redirect_to posts_path, notice: 'Not authorized'
    end
  end

  def current_user_is_admin_or_moder?
    current_user && (current_user.status=='admin' || current_user.status=='moder')
  end

  def log
    if current_user_is_admin_or_moder?
      @activity=Log.new
      @activity.ip_address=request.env['REMOTE_ADDR']
      @activity.user_id=current_user.id
      @activity.username=current_user.username
      @activity.controller=controller_name
      @activity.action=action_name
      @activity.params=params.inspect
      @activity.save
    end
  end
end
