class TableDescription < ApplicationRecord
  include Monitorable
  translates :description
  #globalize_accessors locales: [:en, :fr], attributes: [:description]
  #globalize_validations  # Will use Model.globalize_locales by default
  validates_presence_of  :category, :description
  validates :category, uniqueness: true
  # all the other validations go before the globalize_validations
  #validate :validates_globalized_attributes#, :description, presence: true
  validates :description, presence: true
end
