class EvaluationTypeService < TableService

  def create_header
    sub_header_search = SubHeaderService.search({ argument: @argument })
    sub_header_add = SubHeaderService.add({ argument: @argument })

    {
      table_header: {
        principal: { label: 'denomination', sort_param: 'detail_translations.denomination' },
        details: header_details,
        buttons: { dimension: dimensions[:buttons]}
      },
      table_filters: {
        search: sub_header_search,
        buttons: [sub_header_add].compact,
      },
    }
  end

  def header_details
    elements = []

    conditions.each do |c|
      elements << { label: c[0], dimension: dimensions[c[0]] || 'medium',  } if c[1]
    end

    elements.compact
  end


  def make_block(element)
    return element if @data_type == 'original'
    return element.minimal_block if @minimal

    {
      id: element.id,
      school_id: @current_school.id,
      principal: principal(element),
      details: block_details(element),
      buttons: { dimension: dimensions[:buttons], event: 'contextMenu', data: { argument: @argument, id: element.id } }
    }.compact
  end

  def block_details(element)
    elements = []

    conditions.each do |c|
      elements << {label: c[0],  value: try(c[0], element) || info_standard(c[0], element.try(c[0].to_sym)) } if c[1]
    end

    elements.compact
  end

  def principal(element)
    # options = { 
    #   event: 'goToRecord', 
    #   data: { 
    #     page_name: 'EvaluationTypeHome',
    #     id: element.id,
    #     denomination: element.denomination,
    #     schoolId: @current_school.id
    #   }
    # }
    my_cel = cel([{ class: "principal" }])
    denomination = micro_cel([{ class: "denomination text-bold text-primary"}], element.denomination)
    my_cel[:list] = [denomination].compact
    my_cel[:label] = 'denomination'
    my_cel
  end

  def conditions
    {
      description: true,
    }
  end

  def dimensions
    {
      buttons: 'small'
    }
  end
end