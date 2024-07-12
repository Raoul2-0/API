class Category < ApplicationRecord
  CLUB = 'club' unless const_defined?(:CLUB)
  COORPERATIVE = 'cooperative' unless const_defined?(:COORPERATIVE)
end