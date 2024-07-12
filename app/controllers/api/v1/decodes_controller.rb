class Api::V1::DecodesController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]

  private
  
  # Only allow a list of trusted parameters through.
  def resource_params
    params[:decode_configuration_id] ||= decode_configuration.id
    params[:school_id] = decode_school.id
    params[:cod] ||= uniq_decode_cod if params[:denomination]

    params.permit(:decode_configuration_id, :school_id, :cod, :denomination, :description)
  end

  def decode_configuration
    @decode_configuration ||= params[:decode_configuration_id] ? DecodeConfiguration.find(params[:decode_configuration_id]) : DecodeConfiguration.find_by_group_key(params[:group_key])
  end

  def decode_school
    decode_configuration.common ? School.super_school : current_school
  end

  def uniq_decode_cod
    params[:denomination][0, 5] + Time.current.to_formatted_s.split[1].gsub(':', '')
  end
end
