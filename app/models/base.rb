class Base < ApplicationRecord
  resourcify
  acts_as :detail
  include Monitorable
end