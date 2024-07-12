class AddDefaultToMonitorings < ActiveRecord::Migration[6.1]
  def change
    change_column :monitorings, :status, :integer, default: 4 # when creating a resource, it is automatically set to published
  end
end
