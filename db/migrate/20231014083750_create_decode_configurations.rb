class CreateDecodeConfigurations < ActiveRecord::Migration[6.1]
  def change
    create_table :decode_configurations do |t|
      t.string :group_key, index: true, null: false
      t.boolean :common, default: false
    end
  end
end
