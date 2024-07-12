class CyclePhase < GeneralInfo
  include ActiveModel::Model
  include ActiveModel::Validations

  REQUIRED_ATTRS = %i[id cod denomination cycle_id].freeze
  NOT_REQUIRED_ATTRS = %i[description duration certificate].freeze

  TABLE_ATTRS = REQUIRED_ATTRS + NOT_REQUIRED_ATTRS
  attr_accessor(*TABLE_ATTRS)

  validates(*REQUIRED_ATTRS, presence: true)

  CACHE_VERSION = "cycle-phases-v0"

  def minimal_block
    {
      id: id, 
      denomination: denomination
    }
  end

  def self.by_cycle(cycle_id)
    where(cycle_id: cycle_id)
  end

  def cycle
    Cycle.find(cycle_id)
  end

  def self.db_resources
    Rails.cache.fetch("CyclePhase-#{I18n.locale}") do
      all_phases = []
      general_infos.each do |c|
        category_id = c[0]
        c[1][:cycles].each do |cy|
          cycle_id = cy[0]
          cyls = cy[1]
          all_phases += cyls[:phases].map { |p|  create_phases(p, "#{category_id}#{cycle_id}".to_i)}
        end
      end

      all_phases.compact
    end
  end

  def self.create_phases(phase_obj, cycle_id)
    phase_id = phase_obj[0]
    phs = phase_obj[1]

    el = {}
    el[:id] = phase_id
    el[:cycle_id] = cycle_id
    el[:denomination] = phs[:denomination]
    el[:cod] = phs[:cod]
    el[:description] = phs[:description] || ''
    el[:duration] = phs[:duration]
    el[:certificate] = phs[:certificate]

    CyclePhase.new(el)
  end
end
