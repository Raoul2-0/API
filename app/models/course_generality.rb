class CourseGenerality < ApplicationRecord
  acts_as :detail
  include Monitorable
  include CourseGeneralityModule

  validates :denomination, presence: true
  validates :duration, presence: true

  has_many :courses
      
  scope :by_common, lambda { |term| where("lower(detail_translations.denomination) ILIKE ?", "%#{term}%")}

  def self.fetch_resources(params, parent_model, user)
  
    parameters = {
      parent_model: parent_model,
      to_includes: TO_INCLUDES,
      status: params[:status]
    }
    
    resources = set_resources(MODEL_NAME, parameters)
    
    resources = apply_filters(params, resources, FILTERS)
    # sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
    # resources.reorder(sort)
  end
end
    