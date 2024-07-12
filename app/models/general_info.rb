class GeneralInfo
  include ActiveModel::Model
  include ActiveModel::Validations

  def self.general_infos
    Rails.cache.fetch("schools_general_infos-#{I18n.locale}") do
      YAML.load(File.open(Rails.root.join("config/school_categories/CM/#{I18n.locale}.yml")))[I18n.locale.to_sym]
    end
  end

  def minimal_block
    {
      value: id, 
      label: denomination
    }
  end

  def monitoring
    Monitoring.new({ status: Status::PUBLISHED })
  end

  def self.where(options = {})
    resp = db_resources
    options.each do |key, value|
      resp.select! { |c| value.is_a?(Array) ? value.include?(c.try(key.to_sym)) : c.try(key.to_sym) == value }
    end
    resp
  end

  def self.by_category(category_id)
    where(category_id: category_id)
  end

  # get class levels by cycle id
  def self.by_cycle_id(cycle_id)
    where(cycle_id: cycle_id)
  end

  # ID
  def self.by_id(ids)
    raise ArgumentError, 'Missing cods' if ids.blank?
    
    db_resources.select { |c| ids.is_a?(Array) ? ids.include?(c.id) : c.id == ids }
  end

  def self.find_by_id(id)
    raise ArgumentError, 'Missing id' if id.blank?

    by_id(id.to_i).first
  end

  def self.find(id)
    raise ArgumentError, 'Missing id' if id.blank?

    by_id(id.to_i).first
  end

  def self.find_by_id(id)
    raise ArgumentError, 'Missing id' if id.blank?

    by_id(id.to_i).first
  end

  # COD
  def self.by_cod(cods)
    raise ArgumentError, 'Missing cods' if cods.blank?

    db_resources.select { |c| cods.is_a?(Array) ? cods.include?(c.cod) : c.cod == cods }
  end

  def self.find_by_cod(cod)
    raise ArgumentError, 'Missing cod' if cod.blank?

    by_cod(cod).first
  end



   # set of methods to fetch jobs of profiles

  def self.jobs_profiles_infos(cache_key, path) # schools_general_infos config/school_categories
    #Rails.cache.fetch("#{cache_key}-#{I18n.locale}") do
    YAML.load(File.open(Rails.root.join("#{path}/#{I18n.locale}.yml")))[I18n.locale.to_sym]
    #end
  end
  # def self.fetch_resources(params, school, user)
    

  def self.fetch_jobs_profiles(params)
    jobs_profiles = db_jobs_profiles(params[:argument])
    case params[:sort]
      when "detail_translations.denomination_asc"
        jobs_profiles = sorted_jobs_profiles_asc(jobs_profiles)
      when "detail_translations.denomination_desc"
        jobs_profiles = sorted_jobs_profiles_desc(jobs_profiles)
    end
    jobs_profiles
  end
  

  def self.db_jobs_profiles(category)
    jobs_profiles = []
    # all_jobs_profiles = Rails.cache.fetch("#{category}-#{I18n.locale}") do
    #   all_jobs_profiles = jobs_profiles_infos("schools_#{category}", "config/school_jobs_profiles")
    # end
    all_jobs_profiles = jobs_profiles_infos("schools_#{category}", "config/school_jobs_profiles")
    
    #jobs_profiles.select{|job_profile| job_profile[1][:choice] == 1 || job_profile[1][:choice] == 3}.map { |job_profile|  create_job(job_profile[0], job_profile[1])}
    
    all_jobs_profiles.each do |job_profile|
      case category
        when "jobs"
          jobs_profiles << create_job_profile(category, job_profile[0], job_profile[1]) if job_profile[1][:choice] != 2
        when "profiles"
          jobs_profiles << create_job_profile(category, job_profile[0], job_profile[1]) if job_profile[1][:choice] != 1
      end
    end
    jobs_profiles.compact
  end

  def self.create_job_profile(category, job_profile_id, job_profile_obj)
    job_profile = {}
    job_profile[:id] = job_profile_id
    job_profile[:denomination] = job_profile_obj[:denomination]
    job_profile[:description] = job_profile_obj[:description]
    case category
      when "jobs"
        new_job_profile = Job.new(job_profile)
      when "profiles"
        new_job_profile =  Profile.new(job_profile)
    end
    new_job_profile
  end
  

  def self.sorted_jobs_profiles_asc(jobs_profiles)
    jobs_profiles.sort_by { |job| job.denomination.downcase }
  end

  def self.sorted_jobs_profiles_desc(jobs_profiles)
    sorted_jobs_profiles_asc(jobs_profiles).reverse
  end

end