class Timing < ApplicationRecord
  include Monitorable
  belongs_to :timeable, polymorphic: true
  validates :start_time, :end_time, presence: true
end