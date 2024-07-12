class RemoveTimestampsToCycle < ActiveRecord::Migration[6.1]
  def change
    remove_column :cycles, :created_at
    remove_column :cycles, :updated_at
  end
end
