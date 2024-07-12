class Department < ApplicationRecord
  include Monitorable
  include DepartmentModule
  has_many :serves, class_name: "Serve"

  acts_as :detail
  alias_attribute :minimal_block, :default_minimal_block

  scope :by_common, lambda { |term| where("lower(detail_translations.denomination) ILIKE ?", "%#{term}%") }

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

end
