class CreateCourseServes < ActiveRecord::Migration[6.1]
  def change
    create_table :course_serves do |t|
      t.references :course, null: false, foreign_key: true
      t.references :serve, null: false, foreign_key: true
      t.boolean :is_main_teacher, default: false

      t.timestamps
    end
  end
end
