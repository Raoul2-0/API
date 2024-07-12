class CreateExtraActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :extra_activities do |t|
      t.string :category
      t.string :denomination
      t.string :our_meetings
      t.jsonb :preferences,  null: false, default: '{}'

      t.timestamps
    end
  end
end
