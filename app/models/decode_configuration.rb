class DecodeConfiguration < ApplicationRecord
  include Monitorable
  include DecodeConfigurationModule
  acts_as :detail
  has_many :decodes, dependent: :destroy

  alias_attribute :minimal_block, :default_minimal_block

  scope :by_group, ->(key) { where(group_key: key).distinct }
  scope :by_global, ->(value) {  where(common: value == 'true') }
  scope :by_common, ->(term) { where("lower(detail_translations.denomination) ILIKE :t OR group_key ILIKE :t", t: "%#{term}%")}

  def self.fetch_resources(params, parent_model, user)
    parameters = {
      parent_model: parent_model,
      to_includes: TO_INCLUDES,
      status: params[:status]
    }

    resources = set_resources(MODEL_NAME, parameters)
    params[:global] ||= 'false'

    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort]&.gsub(/_(a|de)sc(!|$)/, ' \1sc\2')&.split('!')&.map(&:to_s) || SORT_DEFAULT
    resources.reorder(sort)
  end

  def school_decodes(school_id)
    JSON.parse(ActiveModelSerializers::SerializableResource.new(decodes.where(school_id: school_id), each_serializer: DecodeSerializer).to_json)
  end

end
