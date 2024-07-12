class CreateDecodes < ActiveRecord::Migration[6.1]
  def change
    create_table :decodes do |t|
      t.references :decode_configuration, null: false, foreign_key: true
      t.references :school, null: false, foreign_key: true
      t.string :cod, index: true, null: false

      t.index %i[decode_configuration_id school_id cod]
    end
  end
end
