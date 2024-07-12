class User < ApplicationRecord
  belongs_to :userable, polymorphic: true, optional: true
  include UserModule
  include Monitorable
  rolify
  after_create :assign_default_role
  validates :password, :presence =>true, :confirmation => true, :length => { :within => 6..40 }, :on => :create
  validates :password, :confirmation => true, :length => { :within => 6..40 }, :on => :update, :unless => lambda{ |user| user.password.blank? }  
  validates_presence_of :email, :first_name, :last_name , :identification_number, :sex, :birthday, :phones, :address #, :email_confirmed
  validates_uniqueness_of :email, :identification_number
  validates :identification_number, length: { is: Constant::USER_IDENTIFICATION_NUMBER_LENGTH }
  validate :jsonbs_against_json_schema
  alias_attribute :gender, :sex

  scope :by_last_first_name, lambda { order(:last_name, :first_name) }
  scope :by_admin,-> { where(is_admin: true) }
  

  def serve(school_id)
    staff_id = userable.id
    Staff.find(staff_id).serves.where(staff_id: staff_id, school_id: school_id)[0]
    #Staff.find(staff_id).serves.find_by_staff_id(staff_id)
  end
  # preferences default values
  # has_defaults(
  #   preferences: proc {
  #     {
  #       school_id: nil, 
  #     }
  #   }
  # )

  # phones default values
  has_defaults(
    birthday: proc {
      {
        date: "",
        country: "",
        city: ""
      }
    }
  )

 # phones default values   
 has_defaults(
  address: proc {
    {
      country: "", 
      region: "",
      city:"", 
      street: "",
      po_box: ""
    }
  }
)

 # address default values   
 has_defaults(
  phones: proc {
    {
      phone_1: "",
      phone_2: "",
      landline: ""
    }
  }
)
  # validate contacts_info and social_media
  def jsonbs_against_json_schema
    validate_json_schema(modality="strict",json_name="birthday",json_name=birthday)
    validate_json_schema(json_name="phones",json_name=phones)
    validate_json_schema(modality="strict",json_name="address",json_name=address)
  end

  def self.default_super_user
    where(is_admin: true).first
  end

  def self.default_super_user_id
    where(is_admin: true).first.id
  end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
         #:recoverable, :rememberable, :validatable

  def user_profile(school_id)
    case self.userable_type
    when User::STAFF
        profile_denomination = self.serve(school_id)&.profile.denomination
        convert_to_snake_case(profile_denomination)
    when User::STUDENT
        "student"
    when User::PARENT
        "parent"
    else
      nil
    end
  end

  def generate_permissions
    permissions = {}

    self.roles.each do |role|
      resource_type = role["resource_type"]
      resource_action = role["name"].to_sym

      next unless resource_type # Skip roles without a resource_type

      permissions[resource_type] ||= {}
      if resource_action == :destroy
        permissions[resource_type]["delete"] = true
      else
        permissions[resource_type][resource_action] = true
      end
    end

    { permissions: permissions }
  end

  def user_permissions_in_school(school_id)
    permissions = {}  # Initialize an empty hash to store permissions
  
    # Iterate through the user's roles
    self.roles.each do |role|
      # Check if the role's resource type matches "School" and the resource_id matches the provided school_id
      next unless role.resource_type == "School" && role.resource_id == school_id

      # Split the role name into controller and action (e.g., "attachment:index" => ["attachment", "index"])
      controller, action = role.name.split(":")
        
      # Initialize the controller in the permissions hash if it doesn't exist
      permissions[controller] ||= {}
        
      # Set the action (index, show, create, update, delete) to true in the permissions hash
      permissions[controller][action.to_sym] = true
    end
  
    { school_id: school_id, permissions: permissions }
  end

  def edit_permissions_in_school(school_id, model, permissions)
    school = School.find(school_id)
    permissions.keys.each do |key|
      permission_name = model + ":" + key
      if permissions[key] == "true"
        self.add_role permission_name, school
      else
        self.remove_role permission_name, school
      end
    end
  end
  

  # Generate permissions for the user
  def create_permissions(school_id)
    school = School.find(school_id)
    sub_schools = school.subtree
    current_local = I18n.locale
    I18n.locale = I18n.default_locale
    u_profile = user_profile(school_id)

    return unless u_profile

    file_path = Rails.root.join("config", "permissions", "#{u_profile}.yml")
    if File.exist?(file_path)
      permissions = load_yaml_without_empty_lines(file_path)
      if permissions
        roles.destroy_all # I remove all existing permissions to reinitialise it
        permissions.each do |permission_name|
          #permission = convert_to_model_and_action(permission_name)
          sub_schools.each do |subschool|
            self.add_role permission_name, subschool
          end
          
        end
      end
    end

    I18n.locale = current_local
  end

  # Return false if role already exists and true if the role was successfully added.
  def add_new_role(role)
    if self.has_role? role
      return false
    else
      self.add_role role
      return true
    end
  end

  def initials 
    first_name[0] + last_name[0]
  end

  def fullname(upcase = false)
    fn = "#{first_name} #{last_name}"

    upcase ? fn.upcase : fn.titleize
  end

  def all_phones(separator = '/')
    resp = ''
   
    phones.each do |phone|
      next if phone[1].blank?

      resp = "#{resp}#{resp.present? ? separator : ''}#{phone[1]}"
    end

    resp
  end

  def complete_address
    resp = ''
    resp += "#{address['street']}"     if address['street']
    resp += " #{address['city'].capitalize}"      if address['city']
    resp += " (#{address['country'].capitalize})" if address['country']
  end

  def complete_birthdate
    resp = ''
    resp += "#{birthdate}"  if birthdate
    resp += " #{birthday['city'].capitalize}"      if birthday['city']
    resp += " (#{birthday['country'].capitalize})" if birthday['country']
  end

  def birthdate
    return if birthday['date'].blank?

    "#{I18n.l(Date.parse(birthday['date']))}"
  end

  def small_gender(upcase = false)
    ss = gender[0]

    upcase ? ss.upcase : ss.titleize
  end

  # def avatar_url
  #   # TODO return here the user avatar URL
  #   p = "https://lh3.googleusercontent.com/fife/AGXqzDltPtTVWUGNL1iGQPMYz_gb2OUc0ncf3xm96rRWMuLhZ4P7B4MFE9A5ciwzRh1E_vqvNK7gBFleqdhD-m65NbVWKofzYUPgHY3PQsbowzUK2o2zrh4ae-wfTsitQzDEEdfndolzw2wrU7bPIO0eqOKYDv7W0IeD6kbNNidbFPpbxvPLCGkxTpouaU-aneMXwa-wfjbr8SjB98bdHbxL029hkISCS_U9ty4hbUf4CuxB1ESBD-mnKrexxoNHbE6qtQWhjxYhlHVY47i7XiMDOtWnXvsaBITqFjrszC9NZtxu35V2E_C0i3-N1E2_GANe9zKkJ9XoRMX9vaBKzXSG9jXrlMwYuOgrUjkHky9-e_263o3U_YAjlQmpXhz3hTTPysiGzqcgQHxF9aNuI2pRUdWQ2irOuFQ00oaXawD1MpB89E3EBeowpC9DNtVsrRut6RtG9_u8_zxdaLk1ll0L0KrDFFksio1ASkGb2O_aA7CYWfpaAxQz_-xoFj44w675PnVoTLHswILchMi3SmepmZ4XNYvbAILjGDBH6gRk3fXVMnF9l6peZxIwULVj0UaziO3a0JUx82iXGDSxmLMHmSt1WfV8pY1ADSGXiqsQ4ddrJIkm7Gy8itp1dqgPUSlhhN9hwNuePV229OygRd5m1xEvSyHtTwMoVbjqIWljNVOroDs7JvujrLnWgsP2F2Os47_mi5vGYHnkaGunetfBChixYyuhuRX4yhSFPpQUX-b8WQ71faxk935npx-b_-CgQRHd7bwoVmkMIrJJJdKUu7QHHg5mGCH_WPciAdKXBPa3_gbh8M8eDztyDaO9AHElCWw9fAnO_Vq7FwMf6OQIoYEYMTJ51K4-oSfKXV2Vzax2bQiyo6rDOiuILoBSXrytiOQgelQjP8UoCdWqtnZLHDQtiTwdqUUFIwlFy6tKA1ncVeLeOL3i4uosQlm8iChsktNWbTgbJ_TjeWo0O7i9Hx24eenrdfyF5dRhnxDztI2fSiWe5OsLP9oHoehA3QZ6kpz5TAz3kGX-6GiYb2JFHxOEyYh99Z1CIaCQbjdDvRhK9e5ynQfHE67Cnge7VlCA0emqnCdR-qY77027rKKdtzvm7SdulKQs4WGkZL4RA36T5GT73p3DnMPqm7gi0AOSgLocqB_v2qm0frYpjHutjh-kYhrC88wssXEcgk2bpMgbTR7aZBc-1GST2vljeNdwyxaalYOtZCCJyD0hjWszBV3rEp1QW--306c8fOxTrSMEzfO__dRciwjkrzUaeqBvGsZjKVPFELKvaqXxIoqBG9UlZJQ0kvk1dChVzVHPZX3w224nQ6IU2g29dKaMI1XCBb_6bNE06Na0-gsntjD_S40cUS2TKuRND_h-etuXUeFYChpUtOF4LDDOPqR0a_UHtxXpLur5Gln5d2Psi-EN89ftaPjNnJa2sr1OTlME6WmoAl5garBbuhcHRErXHTtJX0hFFMz-z0itH01aHW2bB_-oyA7fFnM_spl8nCspNkQTS0Q-oc8ZSZNVoY6nL0uNZHFjWMpdzM71zzKqN66JUF3nK7VO49h6d7jKvykkMJgVDOrW_5Powpkbr4amn_w4IG27NHraetaWGmmmabMiOZn22kCr7ms-9GRWq02UDLjbXD8cyUp4bMuP"
  #   list = {
  #     m: ["1mImHCbK2mEIDInnLjpc9lb99JBm_hk2p", "1LT3_bwGhX3tE3zvKQ7C1uvGcRuQbTpnO", "1Bj46iUdp13GwcONlYcb_rYZRnyFHlx4F"],
  #     f: ["1ilpxzEiGhP-cEXeDo728ElXECU4iXXyx", "1emwxbtjF0he_u_j_LCrBpRNTHc12bDsQ", "15DW_6yQbsc3ECaCHpwmGLq3EDwxC65Fs"]
  #   }
  #   j = "https://cdn.pixabay.com/photo/2018/11/13/22/01/avatar-3814081_1280.png"
  #   #"https://lh3.google.com/u/0/d/#{list[gender[0].downcase.to_sym][rand(3)]}"
  #   p
  # end

  # Token payload 
  def jwt_payload
    {email: email, first_name: first_name, last_name: last_name, sex: sex, birthday: birthday, phones: phones, address: address , email_confirmed: email_confirmed, iau: admin?, userable_type: userable_type, userable_id: userable_id, preferences: preferences}  
  end

  # Create a new token for refreshing an existing one
  def encode_token
    additional_fied = {
      sub: id,
      scp: "user",
      aud: nil,
      iat: Time.now.to_i,
      exp: (Time.now + session_duration.minutes).to_i,
      jti: Time.now.to_i
    }
    JWT.encode(jwt_payload.merge(additional_fied), ENV.fetch('DEVISE_JWT_SECRET_KEY')) # ENV.fetch('DEVISE_JWT_SECRET_KEY')
  end

  def session_duration
    ENV['RAILS_ENV'] == 'production' ? 5_000 : 10_000 # In minutes (the production value schould be a school preference)
  end

  # Save the token after registration
  def save_token(action)
    token = generate_access_token
    # if registration
    if (action == "registration")
      self.update!(confirmation_token: token)
      self.update!(confirmation_sent_at: DateTime.now)
    end
    # if password reset
    if (action == "password_reset")
      self.update!(reset_password_token: token)
      self.update!(reset_password_sent_at: DateTime.now)
    end
    # return the created token
    token
  end

  # Validate an email for a newly registered user
  def validate_email
    self.email_confirmed = true
    self.update(confirmed_at: DateTime.now)
    self.confirmation_token = nil
  end

  # Check if the email was confirmed
  def email_confirmed?
    self.email_confirmed
  end
  
  # Save the expire password reset deadline
  def save_password_reset_expiry_date!
    currentTime = DateTime.now
    self.update!(password_reset_expiry_date: currentTime + Constant::RESET_PASSWORD_DEADLINE)
    currentTime
  end
  
  # Check if the password reset link has expired
  def password_expired?
    self.password_reset_expiry_date < DateTime.now
  end

  # Instance method to set the user as admin
  def set_as_admin
    update(is_admin: true)
  end
  
  # Check is a user is admin
  def admin?
    is_admin == true
  end

  def school_admin?(record, school)
    #binding.pry
    # if record == School
    #   serve(school.id).is_school_admin # admin users have the right to list schools and sub schools in it hierarchy
    # else

    # end
    return false if school.nil? || (record.instance_of?(School) && record.id != school.id)

    serve(school.id).is_school_admin
  end

  User::CATEGORIES.each do |cat|
    define_method "is_#{cat.downcase}?" do
      userable_type == cat
    end
  end


  def permission_in_school?(permission, record, school)
    current_record = record.instance_of?(School) ? record : school

    has_role?(permission, current_record)
  end

  # Check if the reset password  was sent but the passowrd is still not reset
  # def reset_password_confirmed?
  #   return self.reset_password_token != nil and self.reset_password_sent_at != nil
  # end

  # get school preferences (Test to be write)
  def get_school_preferences
    # get the prefered school if exist

    # MAYBE PREFERENCES IS AN OBJECTS NOT STRING
    if self.preferences == "{}"
      preferences = {}
    else
      if self.preferences.key?("school_id")
        if self.preferences[:school_id].nil?
          preferences = {school_id: self.preferences["school_id"]}
        else
          preferences = {}
        end
      else
        preferences = {}
      end
    end

    schools = School.get_schools_by_user(self)
    if schools.present?
      school_numbers = schools.length
      schools = schools.limit(5)
      transformed_schools = schools.map { |school| school.minimal_block }
    end
    
    {
      school_numbers: school_numbers || 0,
      preferences: preferences,
      schools: transformed_schools || []
     }
  end

  def user_home(school_id, sp_id)
    resp = {
      user: self
    }

    if is_student?
      asp = AttendScholasticPeriod.by_user(sp_id, id)&.first
      asp_datas = {}
      if asp 
        asp_datas = {
          id: asp.id,
          classroom: asp.classroom_denomination_with_level,
          speciality: asp.classroom_specialty_denomination_with_desc,
          repeating: asp.repeating ? '(x 2)' : '(x 1)'
        }
      end
      resp[:attend_scholastic_period] = asp_datas
      resp[:attend] = asp&.attend
      resp[:student] = userable
    elsif is_staff?
      resp[:serve] = serve(school_id)
      resp[:staff] = userable
    end
    
    resp
  end

  def delete_in_school(school_id)
    if is_parent?
      userable&.delete
    else
      userable&.delete_in_school(school_id)
    end
    self.delete
  end

private
  
  def load_yaml_without_empty_lines(file_path)
    yaml_data = File.read(file_path)
    yaml_data.gsub!(/^\s*$/, '')  # Remove empty lines
    YAML.safe_load(yaml_data)
  end

  def convert_to_model_and_action(permission_name)
    parts = permission_name.split(":")
    model_name_parts = parts[0].split('_').map(&:capitalize)
    model_name = model_name_parts.join
    action = parts[1].to_sym
    non_application_record_models = ["cycle", "class_level",
                                     "job", "profile", "school_category", "specialty"]
    if non_application_record_models.include?(model_name)
      class_name  = model_name.split('_').map(&:capitalize).join
      begin
        model = Object.const_get(class_name)
      rescue NameError
        # Handle the case where the class doesn't exist
        model = nil
      end 
    else
      model = model_name.constantize
    end
    
    [action, model]
  end

  # Assign a default role (user) to a newly registered user
  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end
  
  # transform school to take few attributes
  def transform_school(school)
    if school.parent["denomination"].nil?
      complete_denomination = school["denomination"]
    else
      complete_denomination = school["denomination"] + " (" + school.parent["denomination"] + ")"
    end
     
    {
      id: school.id, 
      denomination: complete_denomination, 
      attachments: transform_attachment(school.attachments),
    }
  end

  # transform attachments to take only the main logo
  def transform_attachment(attachments)
    {main_logo: [{url: attachments.find_by_category("main_logo")[0]["url"]}] }
  end
end
