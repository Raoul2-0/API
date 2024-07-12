#class UserMailer < ApplicationMailer
class UserMailer <Devise::Mailer
  include Devise::Controllers::UrlHelpers
  before_action  :set_user, only: %w[welcome_email password_reset_email]  # :generate_url_token,
  default from: 'notifications@gmail.com'
  #default from: 'noreply@gmail.com'

  
  def welcome_email
    @url_token = generate_url_token("email_confirm")
    mail(from: ENV.fetch('EMAIL'){'arnaud.fadja.n@arnaud-fadja.it'}, to: @user.email, subject: 'Email Address confimation') 
  end

  def password_reset_email
    @url_token = generate_url_token("password_reset")
    mail(from: ENV.fetch('EMAIL'){'arnaud.fadja.n@arnaud-fadja.it'}, to: @user.email, subject: 'Password reset')
  end


  private 
  # genrate the url to click for validating the email
  def generate_url_token(mode)
    # example https://www.sysaitechnology.com/confirmation/oCjERtrP4nycaRRpycJH
    # https://sysait-staging.herokuapp.com/api/v1/users/password/edit?reset_password_token=2e1b415c65f487ac51aecded6a4b41efb1798b8ee4358ea1034c01af3c53a8c2
    @token = params[:token]
    if mode == "email_confirm"
      temp_url = @token.prepend("confirmation/")
    end
  
    if mode == "password_reset"
      temp_url = @token.prepend("password_reset/")
    end
  
    if ENV.fetch('ELEARNING_HOST')[-1] == "/"
      @url_token = temp_url.prepend(ENV.fetch('ELEARNING_HOST'))
    else
      temp_url = temp_url.prepend("/")
      @url_token = temp_url.prepend(ENV.fetch('ELEARNING_HOST'))
    end
    @url_token
  end
  # set a user
  def set_user
    @user = params[:user]
    @school = School.find_by_identification_number(School::SUPER_IDENTIFICATION_NUMBER)
  end
end
