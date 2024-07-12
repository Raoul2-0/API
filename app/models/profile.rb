class Profile < GeneralInfo
  include ProfileModule
  #has_many :serves, class_name: "Serve"

  #acts_as :detail
  #alias_attribute :minimal_block, :default_minimal_block

  #scope :by_common, lambda { |term| where("lower(detail_translations.denomination) ILIKE ?", "%#{term}%") }

  REQUIRED_ATTRS = %i[id denomination].freeze
  NOT_REQUIRED_ATTRS = %i[description].freeze

  TABLE_ATTRS = REQUIRED_ATTRS + NOT_REQUIRED_ATTRS
  attr_accessor(*TABLE_ATTRS)

  validates(*REQUIRED_ATTRS, presence: true)

  CACHE_VERSION = "profile-v0"

  def minimal_block
    {
      value: id, 
      label: denomination
    }
  end
  

  def self.fetch_resources(params, school, user)
    params[:argument] ||= Profile::DEFAULT_ARGUMENT
    fetch_jobs_profiles(params)
  end

  def self.db_resources
    db_jobs_profiles("profiles")
  end

  def serves
    Serve.where(profile_id: id)
  end

end
