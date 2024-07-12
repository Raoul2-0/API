class School < ApplicationRecord
  include SchoolModule 
  include Attachable
  include Monitorable
  include Institutionalisable
  include Hierarchizable

  
  CACHE_VERSION = "School-v0"
  #has_many :cycles

  has_many :subschools, class_name: "School", foreign_key: "parent_id"
  belongs_to :parent, class_name: "School", optional: true
  
  has_many :attends
  has_many :students, through: :attends

  has_many :serves, class_name: "Serve"
  has_many :staffs, through: :serves

  has_many :decodes
  has_many :decode_configurations, through: :decodes

  belongs_to :theme
  alias_attribute :initials, :default_initials
  delegate :denomination, :colors, to: :theme, prefix: true, allow_nil: true
  
	translates :history, :sub_denomination, :admission_generality, :sub_description, :slogan, :activities_description, :internal_rules,:history,:mission,:vision
  translates :terms_condition, :privacy_policy, :protocol, :cookies_policy, :social, :location_url
	#validates_presence_of :root_id, :parent_id, :denomination, :identification_number, :sub_denomination, :admission_generality, :contacts_info, :social_media, presence:true # , :history
  #validates_uniqueness_of :identification_number
  #validates :identification_number, length: { is: Constant::SCHOOL_IDENTIFICATION_NUMBER_LENGTH }
  #validate :jsonbs_against_json_schema
  #validate :validate_super_school_uniqueness
  before_validation :prevent_identification_number_modification, on: :update

  scope :by_common, lambda { |term| 
    where("lower(denomination) ILIKE :t OR identification_number ILIKE :t", t: "%#{term}%")  
  }

  # scope :by_enabled, lambda do |values|
  #   enabled = values[0]
  #   user = values[1]

  # end

#   validate :only_one_current_period_per_school

#   def only_one_current_period_per_school
#     # Find all scholastic periods for the same school that are current
#     current_periods = school.scholastic_periods
#                              .where("start_date <= ? AND (end_date > ? OR end_date IS NULL)", Date.today, Date.today)
#                              .where.not(id: id) # Exclude the current scholastic period if it already exists in the database

#     # If there is at least one current scholastic period, add an error to the model
#     if current_periods.any?
#       errors.add(:base, "A school can only have one current scholastic period")
#     end
#   end
# end



  has_defaults(
    contacts_info: proc {
      {
        email: "",
        address: "",
        telephone_1: "",
        telephone_2: "",
        mobile_phone: "",
        whatApp_number: "",
        registration_number: "",
      }
    }
  )

 # Soc social_media defaults values   
 has_defaults(
  social_media: proc {
    {
      facebook: "",
      linkedIn: "",
      instagram: "",
      twitter: "",
      youtube: "",
      appStore: "",
      playStore: "",
      windowsStore: "",
    }
  }
)
  # validate contacts and social_media
  def jsonbs_against_json_schema
    validate_json_schema(json_name="contacts_info",json_value=contacts_info)
    validate_json_schema(json_name="social_media", json_value=social_media)
  end

  def minimal_block
    {
      id: id, 
      denomination: name_with_parent(true), 
      avatar_url: avatar_url,
      fallback: initials
    }
  end

  def parameters_config(cod = nil, key = nil)
    resp = parameters.presence || parent&.parameters_config.presence || {}
    resp = resp.dig(cod, key) if (cod && key).present?
    resp = resp[cod] if (cod && !key).present?

    resp
  end


  # TODO: this method should return the school principal
  def principal
    serves&.where(profile_id: 1)&.first
  end

  def attachments_link_file?
    parameters_config('attachments', 'link_file') == true
  end

  def parameters
    # add parameters attribute to school
    # if the value is eempty, popullate with the value in yml file

    YAML.load(File.open(Rails.root.join("config/parameters/school_parameters.yml")))
  end

  def self.general_infos
    YAML.load(File.open(Rails.root.join("config/school_categories/#{I18n.locale}.yml")))[I18n.locale.to_sym]
  end

  def self.categories
    SchoolCategory.fetch_resources
  end

  def cycles
    Cycle.by_category(category_id)
  end

  def class_levels
    ClassLevel.by_category(category_id)
  end

  def category
    SchoolCategory.find(category_id)
  end

  def category_denomination
    category.denomination
  end

  def category_system
    category.system
  end

  def specialties
    Specialty.by_category(category_id)
  end

  def cooperative
    extra_activities.joins(:monitoring).where(category: Constant::TYPE_OF_EXTRA_ACTIVITY[:cooperative], monitorings: { status: Status::PUBLISHED })&.first
  end

  def jobs
    Job.db_resources
  end

  def profiles
    Profile.db_resources
  end

  def current_scholastic_period(sp_id = nil )
    if sp_id 
      ScholasticPeriod.find(sp_id)
    else
      scholastic_periods.by_published.filter_this_period(Time.current)&.first
    end
  end

  def scholastic_period_ids
    scholastic_periods.pluck(:id)
  end

  def self.fetch_resources(params, parent_model, user)
    enabled = params[:enabled] || "false"
    resources = get_schools_by_user(user, enabled)

    # params[:enabled] = [params[:enabled], user] if params[:enabled] # change the value of params[:enabled] and passed also the user

    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT

    resources.nil? || resources.empty? ? [] : resources.reorder(sort)
  end

  # get schools by user: based on the type of user the list of school is obtaing
  def self.get_schools_by_user(user, enabled = "false")
    return [] unless user
    
    all_schools = user.admin? ? admin_schools(user) : try("#{user.userable_type.downcase}_schools", user, enabled)
    all_schools.present? ? merge_subtrees(all_schools) : []
  end

  def self.admin_schools(user)
    return [] unless user&.admin?

    School.by_undeleted
  end

  def self.parent_schools(user)
    return unless user&.userable_type == User::PARENT

    []
  end

  def self.staff_schools(user, enabled)
    return unless user.userable_type == User::STAFF

    staff = user.userable
    if enabled.downcase == "true"
      enabled_serves = staff.enable_serves             
      schools = enabled_serves.any? ? School.where(id: enabled_serves.pluck(:school_id)).includes([:monitoring]): []              
    else 
      schools = staff.schools
    end

    schools
  end

  def self.student_schools(user, enabled)
    return unless user.userable_type == User::STUDENT
    
    student = user.userable
    if enabled.downcase == "true" # there is a active school
      #enabled_school = enabled_schools[0] 
      enabled_attend = student.enableAttend # it is suppose to be of lenght 1 since only one school is enabled at a particular moment          
      schools = enabled_attend.nil? ? [] : School.where(id: enabled_attend["school_id"]).includes([:monitoring])              
    else # The student has any active school
      # the student has any active school therefore all (past) schools should be returned
      schools = student.schools
    end

    schools
  end

  def avatar_url
    main_logo_url
  end

  def sigle_attachment_urls
    urls = {}
    SINGLE_ATTACHMENTS.each do |attachment|
      urls[attachment[0]] = try("#{attachment[0]}_url") || main_banner_url
    end

    urls
  end

  SINGLE_ATTACHMENTS.each do |attachment|
    define_method "#{attachment[0]}_url" do
      common_url(attachment[0])
    end
  end

  def common_url(attach_name = nil)
    return unless attach_name

    attachments.find_by_category(attach_name)[0]&.url
  end
  
  def name(upcase = false)
    upcase ? denomination.upcase : denomination.titleize
  end

  def self.super_school
    School.find_by_identification_number(SUPER_IDENTIFICATION_NUMBER)
  end

  def self.roots
    where(parent_id: super_school_id)
  end

  def self.root_ids
    roots.pluck(:id)
  end

  def super_school?
    @super_school ||= School.super_school_id == id
  end

  def self.super_school_id
    @super_school_id ||= School.super_school.id
  end

  # TODO: Write test
  def subtree
    query = <<-SQL
      WITH RECURSIVE subtree AS (
        SELECT * FROM schools WHERE id = :school_id
        UNION
        SELECT s.* FROM schools s
        JOIN subtree ON s.parent_id = subtree.id
      )
      SELECT * FROM subtree;
    SQL

    @subtree ||= School.find_by_sql([query, { school_id: id }])
  end

  # TODO: Write test
  def ancestries
    query = <<-SQL
      WITH RECURSIVE ancestries AS (
        SELECT * FROM schools WHERE id = :school_id
        UNION
        SELECT s.* FROM schools s
        JOIN ancestries ON s.id = ancestries.parent_id
      )
      SELECT * FROM ancestries;
    SQL

    @ancestries ||= School.find_by_sql([query, { school_id: id }])
  end

  # TODO: Write test
  def self.merge_subtrees(schools)
    merged_schools_set = Set.new(schools)

    schools.each do |school|
      school.subtree.each do |subschool|
        merged_schools_set << subschool
      end
    end

    School.where(id: merged_schools_set.to_a.map(&:id))
  end

  def ancestries_ids
    ancestries.pluck(:id)
  end

  def subtree_ids
    subtree.pluck(:id)
  end

  def root
    School.find(root_id)
  end

  def is_root?
    root_id == id
  end

  def name_with_parent(upcase = false)
    with_parent = parent && !parent.super_school? ? "#{name} (#{parent.name})" : name

    upcase ? with_parent.upcase : with_parent.titleize
  end

  def email
    contacts_info['email']
  end
  def address
    contacts_info['address']
  end

  def main_phone
    contacts_info['telephone_1']
  end

  def secondary_phone
    contacts_info['telephone_2']
  end

  def mobile_phone
    contacts_info['mobile_phone']
  end

  def all_phones(separator = '/')
    resp = ''
    ['main_phone', 'secondary_phone', 'mobile_phone', 'whatApp_number'].each do |phone|
      phone_number = try(phone)
      next if phone_number.blank?

      resp = "#{resp}/#{phone_number}"
    end

    resp
  end

  def whatApp_number
    contacts_info['whatApp_number']
  end

  def registration_number
    contacts_info[:registration_number]
  end

  # enable extra_activity.events to return all events
  def events
    manifestations
  end

  private 

  def validate_super_school_uniqueness
    return unless identification_number == School::SUPER_IDENTIFICATION_NUMBER

    existing_super_school = School.find_by(identification_number: School::SUPER_IDENTIFICATION_NUMBER)
    errors.add(:identification_number, I18n.t('activerecord.errors.models.school.attributes.identification_number.unique_identification_number')) if existing_super_school && existing_super_school != self
  end

  def prevent_identification_number_modification
    errors.add(:identification_number, I18n.t('activerecord.errors.models.school.attributes.identification_number.prevent_identification_number_modification')) if identification_number_was == School::SUPER_IDENTIFICATION_NUMBER && identification_number_changed?
  end
end
