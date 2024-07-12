task :set_root_school => :environment do
  root_school_id = School.find_by_identification_number(School::SUPER_IDENTIFICATION_NUMBER).id
  School.all.each do |school|
    school[:parent_id] = root_school_id if school[:parent_id].nil?
    school[:root_id] = root_school_id if school[:root_id].nil?
    school.save!
  end
end