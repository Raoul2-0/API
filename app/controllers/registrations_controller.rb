class RegistrationsController < Devise::RegistrationsController
  # the following line is required to wrap the "user" key around the received user params
  #wrap_parameters :user, include: [:password, :email, :first_name, :last_name, :sex, :identification_number, :birthday, :phones, :address]
  before_action :parse_params, only: [:create]
  include UserModule
  include StudentModule
  include StaffModule
  include ParentModule

  def create
    build_resource(sign_up_params)
    if User.find_by_email(resource["email"]).present?
      mailused = I18n.t 'registrations.emailUsed'
      render json: { message: mailused, flag: Flag::WARMING}, status: :found # mail already assigned to a user
    else
      begin
        @current_school_id ||= request.headers['X-school-id']
        resource.save!
        case params[:category]
        when 'student'
          save_student(resource, parse_params, current_user)
        when 'staff'
          save_staff(resource, parse_params, current_user)
        when 'parent'
          save_parent(resource, parse_params, current_user)
        else
          # of an ordinary user
          update_monitor(resource, Constant::RESOURCE_METHODS[:create], { user: resource, monitor_attributes: {} })
        end
       
        sign_up(resource_name, resource) if resource.persisted?
        bearer_token = token_refresh(resource)
        confirmation_token = resource.save_token("registration") 
        # Tell the UserMailer to send a welcome email after save
        #school_id = request.headers['school_id'] # request.headers['HTTP_SCHOOL_ID']
        # if school_id ==nil
        #   school_id = request.headers['HTTP_SCHOOL_ID']
        # end
        UserMailer.with(user: resource, school_id: @current_school_id, token: confirmation_token).welcome_email.deliver_now if !Rails.env.test? && @current_school_id
        
        resource.reload
        #if request.headers['category'] == "true"
        if @current_school_id
          mesg = I18n.t 'registrations.mailSent'
          render json: { message: mesg, flag: Flag::SUCCESS}, status: :ok
        else
          mesg = I18n.t 'registrations.mailNotSent'
          render json: { message: mesg, flag: Flag::WARMING}, status: :ok
        end
      rescue Exception => ex
        user = User.where(email: resource["email"]).first
        user&.delete_in_school(@current_school_id)
        mesgError = I18n.t 'registrations.mailSentError'
        render json: { message: mesgError , Error: ex.message,  flag: Flag::ERROR}, status: :internal_server_error
      end 
    end
  end
  #  
  # def update_resource(resource, params)
  #   resource.update_without_password(params)
  # end

  def sign_up_params
    params.permit(:email, :password, :first_name, :last_name, :avatar_url, :sex, :identification_number, :email_confirmed, :disabled, birthday: [:date, :country, :city], phones: [:phone_1, :phone_2, :landline], address: [:country, :region, :city, :street, :po_box])
  end

  protected

  def parse_params
    parsed_params = {}
  
    params.each do |key, value|
      keys = key.split(/\[|\]\[|\]/).reject(&:empty?)
      current_hash = parsed_params
  
      keys.each_with_index do |subkey, index|
        if index == keys.length - 1
          current_hash[subkey.to_sym] = value
        else
          current_hash[subkey.to_sym] ||= {}
          current_hash = current_hash[subkey.to_sym]
        end
      end
    end
    params.merge!(parsed_params)
  end

end