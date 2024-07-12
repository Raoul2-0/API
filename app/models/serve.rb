class Serve < ApplicationRecord
  self.table_name = "serves"
  acts_as :state # to add boolean variable, isEnable, to the table isEnable
  include Monitorable
  include ServeModule

  belongs_to :school
  belongs_to :staff
  
  #has_one :job
  has_one :profile
  has_one :department

  has_many :course_serves
  has_many :courses, through: :course_serves

  validates_presence_of :first_serving_date
  validate :jsonbs_against_json_schema

  delegate :infos, :signature, to: :staff # from staff
  delegate :fullname, :birthdate, :address, :initials, :small_gender, :identification_number, :all_phones, :email, :gender, :complete_address, :complete_birthdate, :avatar_url, :disabled, to: :staff, allow_nil: false  # from user (by staff)
  delegate :user_id, to: :staff, allow_nil: false
  delegate :denomination, to: :school, prefix: true, allow_nil: false

  scope :enable_serve, -> {where(isEnable: true)}

  # address default values   
  has_defaults(
    infos: proc {
      {
        link_curiculum: "",
				compagny_name: "",
				compagny_adress: "",
				compagny_email: "",
				compagny_phone: "",
				personal_website: ""
      }
    }
  )
  # validate contacts_info and social_media
  def jsonbs_against_json_schema
    validate_json_schema(json_name="infos",json_name=infos)
  end

  def staff_attributes # attributes used in the serve serializer
    #binding.pry
    { 
      id: staff[:id],
      infos: infos,
      signature: signature
    }
  end

  def serve_attributes # attributes used in the serve serializer
    {
      id: id,
      school_id: self[:school_id], 
      staff_id: staff_id, 
      #job_id: job_id, 
      profile_id: profile_id, 
      profile_denomination: profile_denomination,
      departement_id: departement_id, 
      first_serving_date: first_serving_date, 
      is_school_admin: is_school_admin
    }
  end

  def user_attributes # attributes used in the student serializer
    default_user_attributes
  end

  def first_serving_date
    I18n.l(self[:first_serving_date], format: :human)
  end
  
  INFOS_PROPERTIES = ["link_curiculum","compagny_name","compagny_adress","compagny_email","compagny_phone","personal_website"]
  INFOS_PROPERTIES.each do |attribute|
    # create a dynamic method that returns the json attribute
    define_method "#{attribute}" do
      infos[attribute]
    end
  end

  def self.fetch_resources(params, parent_model, user)
    
    parameters = {
      parent_model: parent_model,
      to_includes: TO_INCLUDES,
      status: params[:status]
    }
    
    resources = set_resources(MODEL_NAME, parameters)
   
    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
    
    resources.reorder(sort)
  end

  def minimal_block # for now only serve attributes. Will be changed
    { 
      id: id, 
      school_id: self[:school_id], 
      staff_id: staff_id, 
      job_id: job_id, 
      profile_id: profile_id, 
      departement_id: departement_id, 
      first_serving_date: first_serving_date, 
      is_school_admin: is_school_admin
     }
  end

  def transform()
    {
      school: school_denomination,
      first_serving_date: first_serving_date,
      is_school_admin: is_school_admin
    }
  end

  def job
    Job.find(job_id)
  end

  def profile
    @profile ||= Profile.find(profile_id)
  end

  def profile_denomination
    profile.denomination
  end
  
end
