class SchoolService < TableService

  def create_header
    sub_header_search = SubHeaderService.search({ argument: @argument })
    sub_header_add = SubHeaderService.add({ argument: @argument })
    sub_header_print = SubHeaderService.print({ argument: @argument })

    {
      table_header: {
        image: { dimension: dimensions[:image] },
        principal: { label: 'denomination', sort_param: 'schools.denomination', dimension: dimensions[:principal] },
        details: header_details,
        buttons: { dimension: dimensions[:buttons] },
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
      image: { url: element.avatar_url, fallback: element.initials, dimension: dimensions[:image] },
      principal: principal(element),
      details: block_details(element),
      buttons: { dimension: dimensions[:buttons], event: 'contextMenu', data: { id: element.id, argument: @argument } }
    }.compact
  end

  def block_details(element)
    elements = []

    conditions.each do |c|
      elements << { label: c[0], value: try(c[0], element) || info_standard(c[0], element.try(c[0].to_sym)), dimension: dimensions[c[0]] } if c[1]
    end

    elements.compact
  end

  def principal(element)
    options = { 
      event: 'goToRecord', 
      data: { 
        page_name: 'SchoolHome',
        id: element.id,
        denomination: element.name
      }
    }
    my_cel = cel([{ class: "principal" }])
    denomination = micro_cel([{ class: "fullname text-bold text-primary"}], element.name_with_parent(true), options)
    identification_number = micro_cel([{ class: "identification_number text-primary"}], element.identification_number)
    category_denomination = micro_cel([{ class: "category_denomination"}], element.category.full_denomination)

    my_cel[:dimension] = dimensions[:principal]
    my_cel[:list] = [denomination, identification_number, category_denomination].compact
    my_cel[:label] = 'denomination'
    my_cel
  end

  def conditions
    {
      email: true,
      address: true,
      all_phones: true
    }
  end

  # values: small, medium, large, big
  def dimensions
    {
      image: 'small',
      principal: 'medium',
      all_phones: 'mediumm',
      address: 'big',
      buttons: 'small'
    }
  end
end