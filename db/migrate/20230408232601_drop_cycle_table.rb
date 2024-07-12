class DropCycleTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :cycles, force: :cascade, if_exists: true
  end
end
