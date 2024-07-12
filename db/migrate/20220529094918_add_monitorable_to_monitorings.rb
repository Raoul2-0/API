class AddMonitorableToMonitorings < ActiveRecord::Migration[6.1]
  def change
    add_reference :monitorings, :monitorable, polymorphic: true, null: false
  end
end
