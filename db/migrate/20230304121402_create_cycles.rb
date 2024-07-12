class CreateCycles < ActiveRecord::Migration[6.1]
  def change
    create_table :cycles do |t|
      t.belongs_to :scholastic_period
      t.timestamps
    end
  end
end
