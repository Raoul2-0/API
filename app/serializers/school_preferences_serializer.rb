class SchoolPreferencesSerializer < ActiveModel::Serializer
  attributes :school_numbers,  :preferences, :schools
end