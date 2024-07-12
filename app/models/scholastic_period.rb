class ScholasticPeriod < ApplicationRecord
  include Monitorable
  include ScholasticPeriodModule

  acts_as :detail
  
  has_many :attend_scholastic_periods
  has_many :attends, through: :attend_scholastic_periods
  #has_many :cycles
  has_many :courses
  has_many :statistics

  scope :by_common, lambda { |term| where("lower(detail_translations.denomination) ILIKE ?", "%#{term}%") }

  # scope :ordered_by_start_end_dates, -> {
  #   joins(:monitoring)
  #   .order('monitorings.start_date ASC, monitorings.end_date ASC')
  # }
  
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
