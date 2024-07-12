class AddScholasticPeriodIdToCourses < ActiveRecord::Migration[6.1]
  def change
    add_reference :courses, :scholastic_period, null: false, foreign_key: true, default: 1
     # Set the default value of scholastic_period_id 1 for existing records. It should be removed when the project goes in production
  end
end
