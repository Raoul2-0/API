class CreateThemes < ActiveRecord::Migration[6.1]
  def change
    create_table :themes do |t|
      t.string :denomination
      t.jsonb :colors, null: false, default: '{}'
      #t.string :image

      t.timestamps
    end
    add_index :themes, :denomination, unique: true
  end
end
