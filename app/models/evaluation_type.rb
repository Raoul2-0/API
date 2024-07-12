class EvaluationType < ApplicationRecord
  include Monitorable
  include EvaluationTypeModule

  acts_as :detail
  alias_attribute :minimal_block, :default_minimal_block
  has_many :evaluations

  scope :by_common, lambda { |term| where("lower(detail_translations.denomination) ILIKE :t OR group_key ILIKE :t", t: "%#{term}%")}

  def self.fetch_resources(params, school, user)
    decode_configuration_id = params[:decode_configuration_id] || DecodeConfiguration.find_by_group_key(params[:group_key])&.id

    parameters = {
      parent_model: school,
      to_includes: TO_INCLUDES,
      status: params[:status],
      sub_collection: { decode_configuration_id: decode_configuration_id }
    }
    
    resources = set_resources(MODEL_NAME, parameters)
   
    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
    
    resources.reorder(sort)
  end 

end
