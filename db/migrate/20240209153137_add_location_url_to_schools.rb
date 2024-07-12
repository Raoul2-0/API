class AddLocationUrlToSchools < ActiveRecord::Migration[6.1]
  def change
    add_column :schools, :location_url, :string
  end
end
