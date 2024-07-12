class ApplicationController < ActionController::API
  include Pundit::Authorization
  # include Locale # This includes all the functions in the module lib/modules/configure_locale.rb
  #protect_from_forgery with: :null_session?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  #after_action :verify_authorized, except: :index
  #after_action :verify_policy_scoped, only: :index
  before_action :set_locale
  #before_action :configure_permitted_parameters , if: :devise_controller?
  def pundit_user
    { user: current_user, current_school: @current_school } # Additional parameters for the policy class
  end
  protected



  def configure_permitted_parameters
    #devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :sex, :identification_number, birthday: [:date, :country, :city, :birthday_street], phones: [:phone_1, :phone_2, :landline], address: [:country, :city, :street]])
    # :email_confirmed
    #devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :sex, :identification_number, birthday: [:date, :country, :city, :birthday_street], phones: [:phone_1, :phone_2, :landline], address: [:country, :city, :street]) }
  end

  def monitoring_permitted_parameters
    params.permit(:status, :start_date, :end_date)
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    #flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    message = I18n.t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    render json: {message: message, flag: Flag::ERROR}, status: :unauthorized
  end
  # the following two functions define the local language
  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end
      
  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
      
  def default_url_options
    { locale: I18n.locale }
  end 

  # handle a json 
  def render_json_response(resource)
    if resource.errors.empty?
      render json: resource
    else
      
      render json: resource.errors, status: 400
    end
  end
end

