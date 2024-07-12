class CreateTableDescriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :table_descriptions do |t|
      t.string :category
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        TableDescription.create_translation_table! :description =>  :text
      end

      dir.down do
        TableDescription.drop_translation_table!
      end
    end
  end

end
