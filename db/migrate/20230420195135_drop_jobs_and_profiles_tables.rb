class DropJobsAndProfilesTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :jobs, force: :cascade, if_exists: true
    drop_table :profiles, force: :cascade, if_exists: true
  end
end
