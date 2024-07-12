class CreateAttends < ActiveRecord::Migration[6.1]
  def change
    create_table :attends do |t|
      t.belongs_to :school
      t.belongs_to :student
      t.string :registration_number
      t.date :first_enrollment_date

      t.timestamps
    end
    add_index :attends, :registration_number
  end
end



