class CreateStaffs < ActiveRecord::Migration[6.1]
  def change
    create_table :staffs do |t|

      t.json :infos, default: {}
      #t.timestamps (the timestamp is in the user table)
    end
  end
end
