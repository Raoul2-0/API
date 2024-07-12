class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  #before_save :delete_cache_key
  #before_update :delete_cache_key
  after_commit :cancel_resource_cache_key, on: [:update]
  # after_commit :create_resource_cache_key, on: [:create] (Could create inconsistency: for now to avoid)
  include Utils

  def save_and_check_creation_in_default_locale
    if I18n.locale == I18n.default_locale
      self.save!
    else
      # Create and save the resource in the default locale
      attributes = self.attributes # copy the attributes
      temp_locale = I18n.locale
      I18n.locale = I18n.default_locale
      self.update!(attributes) 
    
      # Update the newly created resource with resource_params using I18n.locale as the new locale
      self.reload
      I18n.locale = temp_locale # change the local
      self.update!(attributes)
    end
  end

  scope :by_school, lambda { |parameters|
    # parameters[0] = school_id & parameters[1] is the pluralize version of the resource name (e.g "students")
    School.find_by_id(parameters[0]).send(parameters[1]).includes(parameters[2])#.where.not(monitorings: { status: Status::DELETED }) # .includes([:translations]
    #where(school_id: parameters[0])
    #where(events: {school_id: parameters[0]}).where.not(monitorings: { status: Status::DELETED })
    #self.includes([:school_id]).where(school_id: parameters[0])
  }

  scope :by_cycle_id, -> (cycle_id) { where(cycle_id: cycle_id) } # currently used in classroom and class_level
  
  # scope by status
  scope :by_status, lambda { |status| 
    includes([:monitoring]).where(monitorings: { status: status })
  }

  scope :by_published, -> { by_status(Status::PUBLISHED ) }

  scope :by_undeleted, lambda { 
    includes([:monitoring]).where.not(monitorings: { status: Status::DELETED  })
  }

  scope :by_start_date, lambda { |from|
    where('monitorings.start_date::date >= ?', from) if from
  }

  # find by to (end)
  scope :by_end_date, lambda { |to|
    where('monitorings.end_date::date <= ?', to) if to
  }

  scope :filter_this_period, lambda { |date| 
    table = Monitoring.arel_table
    where(
      table[:start_date].lteq(date)).where(monitorings: { end_date: nil }
    ).or(
    where(
      table[:start_date].lteq(date)).where(table[:end_date].gteq(date))
    )
  }

  scope :by_non_deleted, lambda { where.not(monitorings: { status: Status::DELETED })  } # will be removed
  scope :by_scholastic_period, lambda { |parameters| 
    # parameters[0] = school_id & parameters[1] is scholastic_period_id
    # self.select { |student|  student.attends.find_by_school_id(parameters[0]).attend_scholastic_periods.find_by_scholastic_period_id(parameters[1]) != nil}
    where(attends: {school_id: parameters[0]}).where(attend_scholastic_periods: {scholastic_period_id: parameters[1]} )
  }
  scope :by_category, lambda { |category| where(category: category)}
  scope :order_by_created_at, lambda { |models|
    order(sanitize_sql("#{models}.created_at DESC"))
  }
  # used in the serializer of resource to return the school id

 scope :by_sidebar, lambda {|value| where(sidebar: value)}

 scope :by_foreground, lambda {|value| where(foreground: value)}

  # # find by term
  # scope :by_term, lambda { |term|
  #   where("lower(news.denomination) LIKE ?", "%#{term}%")
  # }

  # return the id 
  def school_id 
    institutions = Institution.where(institutionalisable_id: self.id, institutionalisable_type: self.model_name.name)
    institutions.empty? ? nil : institutions[0][:school_id].to_i
  end

  def short_updated_at
    I18n.l(updated_at, format: :short)
  end

  def short_created_at
    I18n.l(created_at, format: :short)
  end

  def self.apply_filters(params, elements, filters)
    filters.each do |filter|
      filter_value = params[filter].presence || params[filter.to_sym]

      next if filter_value.blank?

      elements = elements.try("by_#{filter}", filter_value)
    end

    elements
  end

  # def self.set_resources(resource_name, params) 
  #   current_school = params[:current_school]
  #   current_school_id = params[:current_school_id]

  #   current_scholastic_period =  params[:current_scholastic_period]
  #   scholastic_period_id = params[:scholastic_period_id]
  #   to_includes = params[:to_includes] || []
    
  #   model = resource_name.camelize.constantize
  #   if resource_name.eql?("monitoring")
  #     defaut_to_includes = [] # the monitoring model is not monitored
  #   else
  #     defaut_to_includes = model.respond_to?(:translations) ? [:monitoring, :translations] : [:monitoring] # to change
  #   end
  #   # to_includes.concat(defaut_to_includes)
  #   to_includes = defaut_to_includes + to_includes
    
  #   resources = if current_school_id && !scholastic_period_id && !current_school
  #                 model.all.by_school([current_school_id, resource_name.pluralize, to_includes])
  #               elsif current_school
  #                 current_school.send(resource_name.pluralize).includes(to_includes)
  #               elsif scholastic_period_id
  #                 model.by_scholastic_period(scholastic_period_id).includes(to_includes)
  #               elsif current_scholastic_period
  #                 current_scholastic_period.send(resource_name.pluralize).includes(to_includes)
  #               else
  #                 model.all.includes(to_includes)
  #               end
  #   #resources = current_school_id ? model.all.by_school([current_school_id, resource_name.pluralize, to_includes]) : model.all.includes(to_includes)
    
  #   if params[:status] # if the status is given filter the corresponding status
  #     status = params[:status].to_i
  #     resources.by_status(status)
  #   else # otherwise filter by non deleted
  #     resources.by_non_deleted
  #   end
  # end



  # new version of self.set_resources. It is mean to be adapted to all resource models
  def self.set_resources(resource_name, params) 
    parent_model = params[:parent_model]
    sub_collection = params[:sub_collection]
    to_includes = params[:to_includes] || []
    
    model = resource_name.camelize.constantize
    if resource_name.eql?("monitoring")
      defaut_to_includes = [] # the monitoring model is not monitored
    else
      defaut_to_includes = model.respond_to?(:translations) ? [:monitoring, :translations] : [:monitoring] # to change
    end
    # to_includes.concat(defaut_to_includes)
    to_includes = defaut_to_includes + to_includes
    if parent_model.nil?
      resources = model.all.includes(to_includes) # default resources retrieval behavior
    elsif sub_collection
      resources = parent_model.send(resource_name.pluralize).where(sub_collection).includes(to_includes)
    elsif parent_model.respond_to?(resource_name.pluralize)
      resources = parent_model.send(resource_name.pluralize).includes(to_includes)
    elsif parent_model.respond_to?(resource_name)
      resources = parent_model.send(resource_name).includes(to_includes)
    else
      resources = model.all.includes(to_includes) # default resources retrieval behavior
    end
    
    
    if params[:status] # if the status is given filter the corresponding status
      status = params[:status].to_i
      resources.by_status(status)
    else # otherwise filter by non deleted
      resources.by_non_deleted
    end
  end

  def default_minimal_block
    {
      value: id, 
      label: denomination
    }
  end


  def formatted_start_date(date)
    date ? I18n.l(date, format: :small) : nil
  end

  def formatted_end_date(date)
    date ? I18n.l(date, format: :small) : nil
  end

  def status
    self.class.name.eql?("Monitoring") ? self[:status] : monitoring.status
  end

  def start_date
    #self.class.name.eql?("Monitoring") ? formatted_start_date(self[:start_date]) : formatted_start_date(monitoring[:start_date])
    date_to_format = self.class.name.eql?("Monitoring") ? self[:start_date] : monitoring[:start_date]
    formatted_start_date(date_to_format)
  end

  def end_date
    #self.class.name.eql?("Monitoring") ? formatted_end_date(self[:end_date]) : formatted_end_date(monitoring[:end_date])
    date_to_format = self.class.name.eql?("Monitoring") ? self[:end_date] : monitoring[:end_date]
    formatted_end_date(date_to_format)
  end

  def default_initials
     denomination.present? ? denomination.split.map(&:first).join[0, 2] : "N/D" 
  end
  
  def default_user_attributes # user attributes that should be used in the serve/student/parent serializer
    { 
      id: user_id,
      fullname: fullname,
      birthdate: birthdate,
      address: address,
      initials: initials,
      small_gender: small_gender,
      identification_number: identification_number,
      all_phones: all_phones,
      email: email,
      gender: gender,
      complete_address: complete_address,
      complete_birthdate: complete_birthdate,
      avatar_url: avatar_url
    }
  end

  # delete cache key before saving to let the data alwas consistent
  def cancel_resource_cache_key
    model_name = self.class.name.downcase
    resource_cache_key = "#{model_name}_#{self[:id]}"
    Rails.cache.delete(resource_cache_key) # delete the cache key related to the get of the single resource 
    #resources_cache_key = "#{model_name.pluralize}"
    #Rails.cache.delete(resources_cache_key) # delete the cache key related to get of resourcesin the index controller
  end

  def create_resource_cache_key
    # Put the resource into the cache with a specific cache key
    model_name = self.class.name.downcase
    resource_cache_key = "#{model_name}_#{self.id}"
    Rails.cache.write(resource_cache_key, self)
  end
end
