class CreateServes < ActiveRecord::Migration[6.1]
  def change
    create_table :serves do |t|
      t.belongs_to :school
      t.belongs_to :staff
      t.belongs_to :job
      t.belongs_to :profile
      t.belongs_to :departement
      t.date :first_serving_date
      t.boolean :is_school_admin, default: false
      

      t.timestamps
    end
  end
end
