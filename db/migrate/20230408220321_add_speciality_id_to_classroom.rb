class AddSpecialityIdToClassroom < ActiveRecord::Migration[6.1]
  def change
    add_column :classrooms, :specialty_id, :integer
  end
end
