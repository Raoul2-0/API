class CreateAttendScholasticPeriods < ActiveRecord::Migration[6.1]
  def change
    create_table :attend_scholastic_periods do |t|
      t.belongs_to :scholastic_period
      t.belongs_to :attend
      t.date :enrollment_date

      t.timestamps
    end
  end
end
