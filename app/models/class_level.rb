require 'active_model'
class ClassLevel < GeneralInfo
  include ClassLevelModule
  include ActiveModel::AttributeMethods
  attr_accessor :id, :cod, :denomination, :category_id, :phase_id, :cycle_id

  define_attribute_methods :id, :cod, :denomination, :category_id, :phase_id, :cycle_id
  
  def attributes
    {
      id: id,
      cod: cod,
      denomination: denomination,
      category_id: category_id,
      phase_id: phase_id,
      cycle_id: cycle_id
    }
  end

  REQUIRED_ATTRS = %i[id cod denomination category_id phase_id].freeze
  NOT_REQUIRED_ATTRS = %i[description].freeze

  TABLE_ATTRS = REQUIRED_ATTRS + NOT_REQUIRED_ATTRS
  attr_accessor(*TABLE_ATTRS)

  validates(*REQUIRED_ATTRS, presence: true)

  def minimal_block
    {
      value: id, 
      label: denomination
    }
  end

  def classroom
    Classroom.find_by_class_level_id(id)
  end

  def self.fetch_resources(params, school_or_cycle, user)
    
    parameters = {
      school_or_cycle: school_or_cycle
    }
    
    set_resources(MODEL_NAME, parameters)
  end

  def self.set_resources(resource_name, parameters)
    school_or_cycle = parameters[:school_or_cycle]

    school_or_cycle ? school_or_cycle.send(resource_name.pluralize) : []
  end


  def self.db_resources
    #Rails.cache.fetch("ClassLevel-#{I18n.locale}") do
      all_levels = []
      general_infos.each do |c|
        category_id = c[0]
        c[1][:cycles].each do |cy|
          cycle_id = cy[0]

          cy[1][:phases].each do |ph|
            phase_id = ph[0]
            phs = ph[1]
           
            all_levels += phs[:class_levels].map { |p|  create_level(p, category_id, "#{cycle_id}#{phase_id}".to_i, cycle_id.to_i)}
          end
        end
      end

      all_levels.compact
    #end
  end

  def self.create_level(level_obj, category_id, phase_id, cycle_id)
    level_id = level_obj[0]
    origin_el = level_obj[1]

    el = {}
    el[:id] = level_id
    el[:phase_id] = phase_id
    el[:category_id] = category_id
    el[:denomination] = origin_el[:denomination]
    el[:cod] = origin_el[:cod]
    el[:description] = origin_el[:description] || ''
    el[:cycle_id] = cycle_id

    ClassLevel.new(el)
  end


end
