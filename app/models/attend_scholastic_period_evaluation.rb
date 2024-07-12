class AttendScholasticPeriodEvaluation < ApplicationRecord
  include Monitorable
  belongs_to :attend_scholastic_period
  belongs_to :evaluation
  acts_as :detail # denomination mapped to appreciation and description to observation
end
