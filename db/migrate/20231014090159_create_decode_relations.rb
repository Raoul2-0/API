class CreateDecodeRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :decode_relations do |t|
      t.references :decode, null: false, foreign_key: true
      t.references :decodable, null: false, polymorphic: true

      t.timestamps
    end
  end
end
