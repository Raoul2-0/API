module Timeable
  extend ActiveSupport::Concern

  included do
    resourcify
    has_one :timing, :as => :timeable
    delegate :start_time, :end_time , :timeable_type, :timeable_id, to: :timing, allow_nil: false
  end
end