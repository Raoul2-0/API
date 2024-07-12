class CreateHomeworks < ActiveRecord::Migration[6.1]
  def change
    create_table :homeworks do |t|
      t.datetime :due_date
      t.boolean :optional, default: false, null: false
      t.references :serve, null: false, foreign_key: true
      t.references :homeworkable, polymorphic: true, null: false
      t.timestamps
    end
  end
end
