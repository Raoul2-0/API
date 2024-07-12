class CreateLocals < ActiveRecord::Migration[6.1]
  def change
    create_table :locals do |t|
      t.integer :capacity
      t.string :localisation
    end
  end
end
