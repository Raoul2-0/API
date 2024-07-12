module Reportable
    extend ActiveSupport::Concern
  
    included do
      resourcify
      has_many :reports, as: :reportable
  
      delegate :reportable_type, :reportable_id, to: :report, allow_nil: true
    end
  
    def report
      reports.first
    end
  end
  