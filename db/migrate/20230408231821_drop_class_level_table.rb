class DropClassLevelTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :class_levels, force: :cascade, if_exists: true
  end
end
