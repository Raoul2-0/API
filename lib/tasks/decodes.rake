require "#{Rails.root}/lib/utils"
require "#{Rails.root}/lib/student_module"
include Utils
include StudentModule
task :decodes, %i[category] => :environment do |_, args|
  super_school = School.super_school
  user = User.default_super_user
  category = args.category
  
  elements = {
    common: 'common_decodes',
    school: 'school_decodes'
  }

  categories = {}
  if category.present?
    categories[category.to_sym] = elements[category.to_sym]
  else
    categories = elements
  end

  I18n.available_locales.each do |locale|
    I18n.locale = locale

    puts "locale: #{I18n.locale}"

    configs = {}
    categories.each do |cat|
      datas = YAML.load(File.open(Rails.root.join("config/decodes/#{cat[1]}/#{locale}.yml")))
      next unless datas

      configs.merge!(datas[locale.to_s])
    end

    configs.each do |config|
      create_decode_configuration(config, super_school, user)
    end
  end
end

private

def create_decode_configuration(config, super_school, user)
  decode_configuration = DecodeConfiguration.find_by_group_key(config[0])
  
  decode_configuration_params = {
    denomination: config[1]['denom'],
    description: config[1]['desc'] || '',
    common: config[1]['common'] == true,
  }

  unless decode_configuration
    decode_configuration_params.merge!({
      group_key: config[0],
      common: config[1]['common'] == true,
    })

    decode_configuration = DecodeConfiguration.new(decode_configuration_params)
    super_school.institutions.create(institutionalisable: decode_configuration)
    decode_configuration = save_resource_update_monitor(decode_configuration, "create", { user: user, monitor_attributes: { status: 4 } })
    puts "Created decode configuration: #{decode_configuration.denomination}"
  end

  if decode_configuration&.translation&.denomination.blank?
    decode_configuration.assign_attributes(decode_configuration_params)
    decode_configuration.save!
    puts "Updated decode configuration: #{decode_configuration.denomination}"
  end

  create_decodes(decode_configuration, config, user, super_school)
end

def create_decodes(decode_configuration, config, user, super_school)
  values = config[1]['values']
  return unless values

  values.each do |value|
    create_decode_in_school(decode_configuration.id, super_school.id, value, user) 

    next if decode_configuration.common

    school_ids = School.root_ids
    school_ids.each do |school_id|
      create_decode_in_school(decode_configuration.id, school_id, value, user) 
    end
  end
end

def create_decode_in_school(decode_configuration_id, school_id, decode, user)
  cod = decode[0]
  new_decode = Decode.by_uniq_kyes(decode_configuration_id, school_id, cod)&.first
  
  decode_params = {
    denomination: decode[1]['denom'],
    description: decode[1]['desc'] || '',
  }

  unless new_decode
    decode_params.merge!({
      decode_configuration_id: decode_configuration_id,
      school_id: school_id,
      cod: cod
    })

    new_decode = Decode.new(decode_params)
    new_decode = save_resource_update_monitor(new_decode, "create", { user: user, monitor_attributes: { status: 4 } })
    puts "Inserted decode: #{new_decode.denomination}"
  end

  return unless new_decode&.translation&.denomination.blank?

  new_decode.assign_attributes(decode_params)
  new_decode.save!
  puts "Updated decode: #{new_decode.denomination}"
end
