class AddDurationToCourseGenerality < ActiveRecord::Migration[6.1]
  def change
    add_column :course_generalities, :duration, :string
  end
end
