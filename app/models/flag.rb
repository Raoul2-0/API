class Flag < ApplicationRecord
  DELETE = 0 unless const_defined?(:DELETE)
  SUCCESS = 1 unless const_defined?(:SUCCESS)
  WARMING = 2 unless const_defined?(:WARMING)
  ERROR = 3 unless const_defined?(:ERROR)
end