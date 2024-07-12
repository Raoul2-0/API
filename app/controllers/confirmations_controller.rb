class ConfirmationsController < ApplicationController
  include UserModule
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # validates an email after creation
   def create
     user = User.find_by_confirmation_token(params[:confirmation_token])
      if user
          user.validate_email
          user.save(validate: false)
          mesg = I18n.t 'registrations.emailConfirmed'
          token_refresh(user)
          render json: { message:  mesg, flag: Flag::SUCCESS}, status: :ok
      else
          mesg = I18n.t 'registrations.emailAlreadyConfirmed'
          render json: { message: mesg, flag: Flag::WARMING}, status: :not_found # the mail is already confirmed or you need to perform a new registration
      end 
   end

   
  # GET /resource/confirmation?confirmation_token=abcdef
   def show
     super
   end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
 
end