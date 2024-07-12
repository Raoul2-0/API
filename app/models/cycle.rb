class Cycle < GeneralInfo
  include CycleModule

  REQUIRED_ATTRS = %i[id cod denomination category_id].freeze
  NOT_REQUIRED_ATTRS = %i[description duration].freeze

  TABLE_ATTRS = REQUIRED_ATTRS + NOT_REQUIRED_ATTRS
  attr_accessor(*TABLE_ATTRS)

  validates(*REQUIRED_ATTRS, presence: true)

  CACHE_VERSION = "cycle-v0"

  def minimal_block
    {
      value: id, 
      label: denomination
    }
  end

  # get all class levels of the current cycle
  def class_levels
    ClassLevel.by_cycle_id(id)
  end

  def classrooms
    Classroom.where(cycle_id: id)
  end

  def category
    SchoolCategory.find(category_id)
  end

  def phases
    CyclePhase.by_cycle(id)
  end

  def self.fetch_resources(params, school, user)
    
    parameters = {
      school: school,
    }
    
    set_resources(MODEL_NAME, parameters)
  end

  def self.set_resources(resource_name, parameters)
    school = parameters[:school]
    if school
      school.send(resource_name.pluralize)
    end
  end

  def self.db_resources
    Rails.cache.fetch("Cycle-#{I18n.locale}") do
      all_cycles = []
      general_infos.each do |c|
        category_id = c[0]
        cyls = c[1]
        
        all_cycles += cyls[:cycles].map { |c|  create_cycle(c, category_id)}
      end

      all_cycles.compact
    end
  end

  def self.create_cycle(cycle_obj, category_id)
    cycle_id = cycle_obj[0]
    cyl = cycle_obj[1]

    el = {}
    el[:id] = cycle_id
    el[:category_id] = category_id
    el[:denomination] = cyl[:denomination]
    el[:cod] = cyl[:cod]
    el[:description] = cyl[:description] || ''
    el[:duration] = cyl[:duration]

    Cycle.new(el)
  end

end
