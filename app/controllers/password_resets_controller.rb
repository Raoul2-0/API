class PasswordResetsController <  ApplicationController
  # Post /password_reset
  # http://localhost:8888/api/v1/users/password/edit?reset_password_token=67TPAUsoVtVF6haz3w2W link available in the mail
  
  def create
    
    @user = User.find_by_email(params[:email])
    if @user.nil?
      mesg = I18n.t 'password_resets.nonexistentemail'
      render json: {message: mesg, flag: Flag::WARMING}, status: :ok
    else
      begin
        password_reset_token = @user.save_token("password_reset") # this line save the token in the reset_password_token field and set the reset_password_sent_at with the current datetime
        mesg = I18n.t 'password_resets.mailSent'
         #UserMailer.with(user: @user, token: password_reset_token).password_reset_email.deliver_now  # this line send an email to the user. The html of the email sent is views/user_mailer/password_reset_email.html.erb
        #UserMailer.with(user: @user, token: password_reset_token).password_reset_email.deliver_later
        #binding.pry
        #@current_school_id = 1
        
        UserMailer.with(user: @user, token: password_reset_token).password_reset_email.deliver_now if @current_school_id
        
        @user.save_password_reset_expiry_date!
        
        render json: {message: mesg, flag: Flag::SUCCESS}, status: :ok
      rescue Exception => ex
        mesgError = I18n.t 'password_resets.mailSentError'
        render json: { message: mesgError , Error: ex.message,  flag: Flag::ERROR}, status: :ok
      end 
    end
  end

  # POST /password_reset
  def update
    @user = User.find_by_reset_password_token(params[:token]) # find the user with corresponding token sent previously
    if @user.nil? # user non found
      mesg = I18n.t 'password_resets.nonexistenttoken' 
      render json: {message: mesg, flag: Flag::WARMING}, status: :ok
    else # user 
      if @user.password_expired?
        mesg = I18n.t 'password_resets.link_expired' 
        render json: {message: mesg, flag: Flag::WARMING}, status: :gone
      else
        begin
          @user.update_attribute(:password,params[:password]) # update the password
          @user.save! # 
          mesg = I18n.t 'password_resets.success'
          render json: {message: mesg, flag: Flag::SUCCESS}, status: :ok
        rescue Exception => ex
          #User.where(email: @user["email"]).delete_all 
          mesgError = I18n.t 'password_resets.updatePasswordError'
          render json: { message: mesgError , Error: ex.message,  flag: Flag::ERROR}, status: :ok
        end
      end
    end
  end
end
