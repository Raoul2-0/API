class SchoolCategory < GeneralInfo
  include ActiveModel::Model
  include ActiveModel::Validations

  REQUIRED_ATTRS = %i[id cod denomination system].freeze
  NOT_REQUIRED_ATTRS = %i[description specialties cycles].freeze

  TABLE_ATTRS = REQUIRED_ATTRS + NOT_REQUIRED_ATTRS
  attr_accessor(*TABLE_ATTRS)

  validates(*REQUIRED_ATTRS, presence: true)

  CACHE_VERSION = "SchoolCategory-v0"
  
  def minimal_block
    {
      value: id, 
      label: full_denomination
    }
  end

  def full_denomination
    "#{denomination}(#{system})"
  end

  def schools
    School.where(category_id: id)
  end

  def cycles
    Cycles.where(category_id: id)
  end

  def pecialties
    Specialty.where(category_id: id)
  end

  def self.fetch_resources(params, school, user)

    db_resources
  end

  def self.db_resources
    Rails.cache.fetch("SchoolCategory-#{I18n.locale}") do
      resp = []
      general_infos.each do |c|
        category_id = c[0]
        cat = c[1]
        el = {}
        el[:id] = category_id
        el[:cod] = cat[:cod]
        el[:denomination] = cat[:denomination]
        el[:description] = cat[:description]
        el[:system] = cat[:system]

        resp << SchoolCategory.new(el)
      end

      resp.compact
    end
  end

end
