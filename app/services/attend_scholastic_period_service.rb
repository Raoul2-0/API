class AttendScholasticPeriodService < TableService

  def create_header
    sub_header_search = SubHeaderService.search({ argument: @argument })
    sub_header_add = SubHeaderService.add({ argument: @argument })
    sub_header_print = SubHeaderService.print({ argument: @argument })

    {
      table_header: {
        image: {},
        principal: { label: 'fullname', sort_param: 'user.first_name' },
        details: header_details,
        buttons: { dimension: dimensions[:buttons]}
      },
      table_filters: {
        search: sub_header_search,
        buttons: [sub_header_add, sub_header_print].compact,
      },
    }
  end

  def header_details
    elements = []

    conditions.each do |c|
      elements << { label: c[0], dimension: dimensions[c[0]] || 'medium' } if c[1]
    end

    elements.compact
  end


  def make_block(element)
    return element if @data_type == 'original'

    {
      id: element.id,
      image: { url: element.avatar_url, fallback: element.initials },
      principal: principal(element),
      details: block_details(element),
      buttons: { dimension: dimensions[:buttons], event: 'contextMenu', data: buttons_data(element) }
    }.compact
  end

  def buttons_data(element)
    { 
      argument: @argument, 
      id: element.id, 
      user_id: element.user_id,
      fullname: element.fullname 
    }
  end

  def block_details(element)
    elements = []

    conditions.each do |c|
      elements << {label: c[0],  value: try(c[0], element) || info_standard(c[0], element.try(c[0].to_sym)) } if c[1]
    end

    elements.compact
  end

  def address(element)
    info_standard('address', element.complete_address)
  end

  def birthdate(element)
    info_standard('birthdate', element.complete_birthdate)
  end

  def principal(element)
    my_cel = cel([{ class: "principal" }])
    options = { 
      event: 'goToRecord', 
      data: { 
        page_name: 'Student',
        id: element.id,
        denomination: element.fullname
      }
    }
    fullname = micro_cel([{ class: "fullname text-bold text-primary"}], element.fullname(true), options)
    identification_number = micro_cel([{ class: "identification_number text-primary"}], element.identification_number)
    registration_number = micro_cel([{ class: "registration_number text-bold"}], element.registration_number)
    classroom = micro_cel([{ class: "text-bold classroom"}], element.classroom_denomination)
    phone_number = micro_cel([{ class: "phone_number"}], element.all_phones)
    email = micro_cel([{ class: "email"}], element.email)
    gender = micro_cel([{ class: "gender"}], element.small_gender(true))

    my_cel[:list] = [fullname, identification_number, registration_number, classroom, phone_number, email, gender].compact
    my_cel[:label] = 'fullname'
    my_cel
  end

  def parent(element)
    my_cel = cel([{ class: "parent" }])

    fullname = micro_cel([{ class: "fullname text-uppercase text-primary"}], element.parent_fullname)
    email = micro_cel([{ class: "email"}], element.parent_email)
    phone_number = micro_cel([{ class: "phone_number"}], element.parent_all_phones)
    complete_address = micro_cel([{ class: "phone_number"}], element.parent_complete_address)
   
    my_cel[:list] = [fullname, phone_number, email, complete_address].compact
    my_cel
  end

  def fees_status(element)
    fees_colors = {
      unpaid: 'red',
      paid: 'green',
      partly: 'warning'
    }

    value = element.fees_status
    options = {
      value: {
        text: value,
        icon: {
          name: "fas fa-circle",
          class: "text-#{fees_colors[value.to_sym]}",
          size: "0.8rem",
        }
      }
    }

    info_standard('fees_status', nil, options)
  end

  def enrollment_status(element)
    fees_colors = {
      inactive: 'red',
      active: 'green',
      pending: 'warning'
    }

    value = element.enrollment_status
    options = {
      value: {
        text: value,
        icon: {
          name: "fas fa-circle",
          class: "text-#{fees_colors[value.to_sym]}",
          size: "0.8rem",
        }
      }
    }

    info_standard('enrollment_status', nil, options)
  end

  def repeating(element)
    
    options = {
      value: {
        icon: {
          name: "fas fa-circle",
          class: "text-#{element.repeating ? 'warning' : 'green'}",
          size: "0.8rem",
        }
      }
    }

    info_standard('repeating', nil, options)
  end


  def conditions
    {
      birthdate: true,
      address: true,
      parent: true,
      fees_status: true,
      enrollment_date: true,
      enrollment_status: true,
      repeating: true,
    }
  end

  def dimensions
    {
      buttons: 'small'
    }
  end
end