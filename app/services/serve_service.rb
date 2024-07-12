class ServeService < TableService

  def create_header
    sub_header_search = SubHeaderService.search({ argument: @argument })
    #sub_header_add = SubHeaderService.add({ argument: @argument })

    add_options = {
      data: { 
        argument: @argument,
        formParams: {
          modalClass: 'noPadding'
        } 
      }
    }
    sub_header_add = SubHeaderService.add(add_options)

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
        buttons: [ sub_header_add, sub_header_print].compact,
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
    return element.minimal_block if @minimal

    {
      id: element.id,
      image: { url: element.avatar_url, fallback: element.initials },
      principal: principal(element),
      details: block_details(element),
      buttons: { dimension: dimensions[:buttons], event: 'contextMenu', data: { argument: @argument, id: element.id, fullname: element.fullname } }
    }.compact
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
        page_name: 'Serve',
        id: element.id,
        denomination: element.fullname
      }
    }
    fullname = micro_cel([{ class: "fullname text-bold text-primary"}], element.fullname(true), options)
    #identification_number = micro_cel([{ class: "identification_number text-primary"}], element.identification_number) (to be replaced by )
    phone_number = micro_cel([{ class: "phone_number"}], element.all_phones)
    email = micro_cel([{ class: "email"}], element.email)
    #gender = micro_cel([{ class: "gender"}], element.small_gender(true))
    link_curiculum = micro_cel([{ class: "link_curiculum"}], element.link_curiculum)
    personal_website = micro_cel([{ class: "link_curiculum"}], element.personal_website)

    my_cel[:list] = [fullname,  phone_number, email,link_curiculum, personal_website ].compact
    my_cel[:label] = 'fullname'
    my_cel
  end


  


  def conditions
    {
      birthdate: true,
      address: true,
      first_serving_date: true,
      is_school_admin: true
    }
  end

  def dimensions
    {
      buttons: 'small'
    }
  end
end