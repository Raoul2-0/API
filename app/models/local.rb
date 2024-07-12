class Local < ApplicationRecord
  include Monitorable
  include LocalModule

  acts_as :detail
  alias_attribute :minimal_block, :default_minimal_block
  has_many :evaluations

  scope :by_common, lambda { |term| where("lower(detail_translations.denomination) ILIKE ?", "%#{term}%")}

  def self.fetch_resources(params, parent_model, user)
    
    parameters = {
      parent_model: parent_model,
      to_includes: TO_INCLUDES,
      status: params[:status]
    }
    
    resources = set_resources(MODEL_NAME, parameters)
   
    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
    resources.reorder(sort)
  end

  def check_local_availability?(evaluation_date, start_time, end_time) 
    if public_evaluations.any? { |evaluation| evaluation.day_time_slot_overlap?(evaluation_date, start_time, end_time) }
      # if the current evaluation date togheter with the start and end time overlap with at least one evaluation then return false
      false
    else
      true # there is any overlap with the other evaluations
    end
  end
 
  # get evaluations associated to local whose status is published
  def public_evaluations
    evaluations.by_published
  end
end
