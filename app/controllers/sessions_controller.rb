class SessionsController < Devise::SessionsController
  include UserModule
  include Utils#, only: [:get_user_by_id]
  public :get_resource_by_id # this makes available only the method :get_resource_by_id from Utils module
  #skip_before_action :verify_authenticity_token 
  
  
  def create
    if params["user"]
      @user = User.find_by_email(params["user"]["email"])
      password = params["user"]["password"]
    else
      @user = User.find_by_email(params["email"])
      password = params["password"]
    end
    if password.nil? 
      mesg = I18n.t 'sessions.inexistentPassword'
      #response.headers['status'] = 401
      render json: { message: mesg, flag: Flag::WARMING }, status: :unprocessable_entity
    else
      if !@user.nil? && @user.disabled
        mesg = I18n.t 'sessions.inactive'
        render json: { message: mesg, flag: Flag::WARMING }, status: :ok
      elsif !@user.nil? && @user.valid_password?(password)
        bearer_token = token_refresh(@user)
        render json: {bearer_token: bearer_token.split.last, flag: Flag::SUCCESS}, status: :ok
      else
        mesg = I18n.t 'sessions.loginfailed'
        render json: { message: mesg, flag: Flag::ERROR }, status: :unprocessable_entity
      end
    end
  end

  def login_as_another_user
    if current_user && current_user[:is_admin]==true
      @user = get_resource_by_id(params["user_id"], "user")
      if @user.nil?
        mesg = I18n.t 'sessions.loginfailed'
        render json: { message: mesg, flag: Flag::ERROR }, status: :ok
      else 
        bearer_token = token_refresh(@user)
        render json: {bearer_token: bearer_token.split.last, flag: Flag::SUCCESS}, status: :ok
      end
    else
      mesg = I18n.t 'sessions.notSuperAdmin'
      render json: { message: mesg, flag: Flag::ERROR }, status: :ok
    end
  end
  
  private

  # def respond_with(resource, _opts = {})
  #   render_json_response(resource)
  # end

  def respond_to_on_destroy
    head :no_content
  end

end