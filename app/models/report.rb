class Report < ApplicationRecord
    include ReportModule
    include Monitorable
    include Attachable

    acts_as :detail
    belongs_to :reportable, polymorphic: true
    
    validates :denomination, presence: true

    scope :by_reportable_type, lambda { |reportable_type| where(reportable_type: reportable_type) }

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