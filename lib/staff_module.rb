module StaffModule
  DEFAULT_ARGUMENT = 'staffs' unless const_defined?(:DEFAULT_ARGUMENT)
  
  def save_staff(resource, parameters, user = current_user, school_id = request.headers['X-school-id'])
    staff_attributes = parameters[:staff_attributes]
    staff = Staff.create!(calculate_staff_attributes(staff_attributes))
    staff.reload
    resource.update!({"userable_type" => "Staff", "userable_id" => staff.id})
  
    serve_params = { 
      school_id: school_id.to_i, 
      staff_id: staff.id,
      #"job_id" => parameters[:serve_attributes]["job_id"],
    }.merge(calculate_serve_attributes(parameters[:serve_attributes]))
    serve = Serve.create!(serve_params)
    serve.reload
  
    [resource, staff, serve].each do |value|
      update_monitor(value, Constant::RESOURCE_METHODS[:create], { user: user, monitor_attributes: {} })
    end
    
    resource.create_permissions(school_id.to_i)
  end

  def calculate_staff_attributes(attributes)
    return {} unless attributes[:infos]

    {
      infos: {
        link_curiculum: attributes[:infos][:link_curiculum],
				    compagny_name: attributes[:infos][:compagny_name],
				    compagny_adress: attributes[:infos][:compagny_adress],
				    compagny_email: attributes[:infos][:compagny_email],
				    compagny_phone: attributes[:infos][:compagny_phone],
				    personal_website: attributes[:infos][:personal_website]
      }
    }
  end

  def calculate_serve_attributes(attributes)
    return {} unless attributes
    
    {
      profile_id: attributes[:profile_id], 
      departement_id: attributes[:departement_id], 
      first_serving_date: attributes[:first_serving_date], 
      is_school_admin: attributes[:is_school_admin]
    }
  end

  def staff_params(staff_extra = {})
    {
      staff_attributes: {
        infos: {
          link_curiculum: "https://www.sysaitechnology.com/about",
          compagny_name: "System Afrik Information Technology",
          compagny_adress: "Via Antonio Fortunato Oroboni, 80, 44122 Ferrara FE",
          compagny_email: "sysaitechnology@gmail.com",
          compagny_phone: "+39 3271852672",
          personal_website: "https://www.sysaitechnology.com/"
        }.merge(staff_extra[:staff_infos] || {}),
      },
      serve_attributes: {
        job_id: 5,
        profile_id: 5,
        departement_id: 1,
        first_serving_date: "10/09/2002",
        is_school_admin: false
      }.merge(staff_extra[:serve_attributes] || {}),
    }
  end
end