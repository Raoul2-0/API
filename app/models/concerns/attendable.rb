module Attendable
  extend ActiveSupport::Concern

  included do
    has_many :attends
    has_many :schools, through: :attends
  end
end