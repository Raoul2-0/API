task :set_scholastic_period_in_statistics => :environment do
  scholastic_period_id = ScholasticPeriod.first.id
  Statistic.all.each do |statistic|
    statistic[:scholastic_period_id] = scholastic_period_id if statistic[:scholastic_period_id].nil?
    statistic.save!(validate: false)
  end
end