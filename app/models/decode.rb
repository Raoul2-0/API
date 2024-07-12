class Decode < ApplicationRecord
  include Monitorable
  include DecodeModule
  include Decoder
  acts_as :detail
  belongs_to :decode_configuration
  belongs_to :school
  

  alias_attribute :minimal_block, :default_minimal_block

  delegate :denomination, to: :school, prefix: true, allow_nil: true

  scope :by_uniq_kyes, ->(dec_conf_id, school_id, cod) { where(decode_configuration_id: dec_conf_id, school_id: school_id, cod: cod) }
  scope :by_common, ->(term) { where("lower(detail_translations.denomination) ILIKE :t OR cod ILIKE :t", t: "%#{term}%")}

  def self.fetch_resources(params, school, user)
    decode_configuration = DecodeConfiguration.find_by_group_key(params[:group_key])
    school = decode_configuration.common ? School.super_school : school

    parameters = {
      parent_model: school,
      to_includes: TO_INCLUDES,
      status: params[:status],
      sub_collection: { decode_configuration_id: decode_configuration.id }
    }
    
    resources = set_resources(MODEL_NAME, parameters)
    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
    
    resources.reorder(sort)
  end

  def school_id
    self[:school_id]
  end

end
