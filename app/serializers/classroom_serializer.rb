class ClassroomSerializer < ActiveModel::Serializer
  attributes :id, :denomination, :number_of_students, :description, :class_level_id, :local_id, :cycle_id, :specialty_id
end
