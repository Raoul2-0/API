module Serveable
  extend ActiveSupport::Concern

  included do
    has_many :serves, class_name: "Serve"
    has_many :staffs, through: :serves, class_name: "Serve"
  end
end