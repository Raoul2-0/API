
module Monitorable
  extend ActiveSupport::Concern

  included do
    resourcify
    has_one :monitoring, :as => :monitorable
    delegate :create_who_fullname, :update_who_fullname, :status, :start_date, :end_date , :monitorable_type, :monitorable_id, to: :monitoring, allow_nil: false
  end
end