class Api::V1::TablesController < Api::V1::BaseController 

  private

  def table_header_params
    global_params
  end

  def table_body_params
    resp = {
      elements: organize_per_page(@elements)
    }.merge(global_params)

    resp.merge!({minimal: true}) if params[:minimal].present?
    resp
  end

  def global_params
    {
      current_school: current_school,
      table_ref: params[:table_ref],
      current_user: current_user,
      argument: argument,
      data_type: @data_type,
      params: params
    }
  end

  def argument
    @argument ||= params[:argument] || @Resource::DEFAULT_ARGUMENT
  end

end