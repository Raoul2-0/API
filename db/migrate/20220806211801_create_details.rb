class CreateDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :details do |t|
      t.actable # shortcut for t.integer :actable_id and t.string  :actable_type
      t.timestamps
    end
    reversible do |dir|
      dir.up do
        Detail.create_translation_table! denomination: :string, description: :text
      end

      dir.down do
        Detail.drop_translation_table!
      end
    end
  end
end
