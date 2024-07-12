class Specialty < GeneralInfo
 
  REQUIRED_ATTRS = %i[id cod denomination category_id].freeze
  NOT_REQUIRED_ATTRS = %i[description group].freeze
  MODEL_NAME = 'specialty'

  TABLE_ATTRS = REQUIRED_ATTRS + NOT_REQUIRED_ATTRS
  attr_accessor(*TABLE_ATTRS)

  validates(*REQUIRED_ATTRS, presence: true)

  def classrooms
    Classroom.where(specialty_id: id)
  end

  def self.fetch_resources(params, school, user)
    
    parameters = {
      school: school,
    }
    
    
    resources = set_resources(MODEL_NAME, parameters)
   
    resources
  end


  def self.set_resources(resource_name, parameters)
    school = parameters[:school]
    if school
      school.send(resource_name.pluralize)
    end
  end

  def self.by_category(category_id)
    where(category_id: category_id)
  end

  def denomination_description 
    description.present? ? "#{denomination} (#{description})" : denomination
  end

  def minimal_block
    {
      value: id, 
      label: denomination_description
    }
  end

  def self.db_resources
    Rails.cache.fetch("Specialty-#{I18n.locale}") do
      all_specialties = []
      general_infos.each do |c|
        category_id = c[0]
        spe = c[1]
        
        all_specialties += spe[:specialties].map { |c|  create_specialty(c, category_id)}
      end

      all_specialties.compact
    end
  end

  def self.create_specialty(specialty_obj, category_id)
    specialty_id = specialty_obj[0]
    spe = specialty_obj[1]

    el = {}
    el[:id] = specialty_id
    el[:group] = spe[:group]
    el[:category_id] = category_id
    el[:denomination] = spe[:denomination]
    el[:cod] = spe[:cod]
    el[:description] = spe[:description] || ''

    Specialty.new(el)
  end

end
