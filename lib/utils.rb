module Utils
  # similar to get_resource_by_id
  def get_resource_by_record_type_id(record_type, record_type_id)
    resource_name = record_type.camelize.constantize
    @resource = resource_name.find_by_id(record_type_id)
  end

  def skip_authorization
    is_eschool? || current_user&.is_admin?
  end

  def is_eschool?
    service_name == Constant::SERVICES_NAMES[0]
  end
  
  # validate email
  def validate_email(email)
    temp_response = {}

    if email.blank?
      temp_response['mesg'] = I18n.t('missing_email', scope: "global")
      temp_response['flag'] = Flag::ERROR 
    elsif is_email?(email).blank?
      temp_response['mesg'] = I18n.t('invalid_email', scope: "global")
      temp_response['flag'] = Flag::ERROR 
    # elsif NewsLetter.find_by_email(email)
    #   temp_response['mesg'] = I18n.t('email_already_used', scope: "global")
    #   temp_response['flag'] = Flag::WARMING 
    end
    temp_response
  end
  # check if an email is valid
  def is_email?(str)
    # We use !! to convert the return value to a boolean
    !!(str =~ /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/)
  end

  # validates jsonb values
  def validate_json_schema(modality="", schema_path="", json_name, json_value)
    schema ||= File.read(File.join(Rails.root, 'app', 'models', 'json_schema', self.class.name.downcase ,json_name+".json"))
    json_name_errors = JSON::Validator.fully_validate(schema,json_value, strict: true ? modality=="strict": false, validate_schema: true)  #strict option, which marks every attribute as required and do not allow additional attribute.
    json_name_errors.each do |error|
        errors.add(:json_value, error)
    end
  end

  # Method to update the monitor related to a resource when doin CUD on it 
  def update_monitor(resource, method, update_parameters = {} )
    user = update_parameters[:user]  || current_user
    nested_denomination = update_parameters[:nested_denomination]
    attributes = update_parameters[:monitor_attributes] || monitoring_permitted_parameters || {}

    # if the action is not monitorable set the current user to default admin user defines in base_controller
    user_id = user ? user.id : User.default_super_user_id

    attributes[:create_who_id] ||= user_id
    attributes[:update_who_id] = user_id
    
    case method
      when Constant::RESOURCE_METHODS[:create]
        monitor = Monitoring.create(monitorable: resource)
        #attributes = { status: Status::ACTIVATED }.merge(attributes)
      else # "update" or "delete"
        monitor = resource.monitoring
        attributes.merge!(status: Status::DELETED) if method.eql?(Constant::RESOURCE_METHODS[:delete])
    end

    if attributes
      monitor.update!(attributes) if monitor
    else
      nil # raise en exception. To implement futher
    end

    if nested_denomination 
      nested_monitoring(resource, method, nested_denomination, { user: user })
    end 
  end

  # Save created/updated/deleted resource and update the corresponding monitor
  def save_resource_update_monitor(resource, method, parameters = {})
    # user = parameters[:user]
    user = parameters[:user] || try('current_user')
    
    new_parameters = parameters[:new_parameters]
    nested_denomination = parameters[:nested_denomination]
    monitor_attributes = parameters[:monitor_attributes].presence || {}

    case method
    when Constant::RESOURCE_METHODS[:create]
      resource.save!
      update_monitor(resource, method, { user: user, monitor_attributes: monitor_attributes, nested_denomination: nested_denomination }) # monitor who is creating the resource
    when Constant::RESOURCE_METHODS[:update]
      resource.update!(new_parameters)
      update_monitor(resource, method,{ monitor_attributes: monitor_attributes}) # monitor who is updating the resource
    when Constant::RESOURCE_METHODS[:destroy]
      update_monitor(resource, method, {monitor_attributes: monitor_attributes}) # monitor who is deleting the resource
    end
    resource.reload
  end
  

  
  # monitoring nested resources after creation/update/delete of a parent resource
  def nested_monitoring(resource, method, nested_denomination, update_parameters = {})
    user = update_parameters[:user] || current_user

    if resource.respond_to?(nested_denomination.pluralize)
      (resource.send(nested_denomination.pluralize)).each do |nested_resource|
        update_monitor(nested_resource, method, { user: user })
      end
    else
      update_monitor(resource.send(nested_denomination), method, { user: user })
    end    
    
  end

  # show resources by filtering the deleted ones
  def filter_resources(resources)
    resources.empty? ? [] : resources.select { |resource| !is_deleted?(resource)}
  end

  # returns true or false if a resource is deleted using the monitoring policy
  def is_deleted?(resource)
    if resource.respond_to?(:monitoring) # check if the resource is monitored
      resource.monitoring.nil? ? false : resource.monitoring[:status].eql?(Status::DELETED)
    else
      false # a resource without monitor is considered as deleted
    end
  end

  # get a user by id 
  def get_user_by_id(user_id) 
    @user = Rails.cache.fetch("user_#{user_id}") do
      user ||= {}
      user[user_id] ||= User.find_by_id(user_id)
    end
  end

  # get a resource by id. NB this method should always be used everytime a resource has to be retrieved
  def get_resource_by_id(resource_id,resource_name)
    return unless resource_id

    #resource_cached = Rails.cache.fetch("#{resource_name.downcase}_#{resource_id}") do
    #  resource ||= {}
    #  resource[resource_id] ||= resource_name.camelize.constantize.find_by_id(resource_id)
    #end

    resource_cached = resource_name.camelize.constantize.find_by_id(resource_id)
    resource_cached
  end

  def convert_to_snake_case(input_string)
    # Replace spaces and underscores with underscores
    snake_case = input_string.downcase.gsub(/[\s_]+/, '_')
    
    # Remove non-word characters except underscores
    snake_case.gsub(/[^a-z0-9_]/, '')
  end
  # generate two random timestamp in the range [Time.now - 6months, Time.now + 6months]
  def generate_random_date
    # Generate random timestamps within the range of 6 months ago and 6 months from now
    six_months_seconds = 6 * 30 * 24 * 60 * 60

    # Get the current time
    current_time = Time.now.to_i

    # Generate a random number of seconds within the 6 months range
    random_seconds_1 = rand(-six_months_seconds..six_months_seconds)
    random_seconds_2 = rand(-six_months_seconds..six_months_seconds)

    # Convert random seconds to Time objects
    random_time_1 = Time.at(current_time + random_seconds_1)
    random_time_2 = Time.at(current_time + random_seconds_2)

    # Ensure random_time_1 is earlier than random_time_2
    random_time_1, random_time_2 = random_time_2, random_time_1 if random_time_1 > random_time_2
  end
end