class Submission < ApplicationRecord
   acts_as :detail
    include Monitorable
    include Attachable
    include SubmissionModule

  LIMIT_ATTACHMENTS = { images: 5 } unless const_defined?(:LIMIT_ATTACHMENTS)
    
  validates :denomination, presence: true
  validates :description, presence: true
  validates :attend_scholastic_period, presence: true
  validates :homework, presence: true

    belongs_to :attend_scholastic_period
    belongs_to :homework


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