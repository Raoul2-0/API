class Api::V1::BaseController < ApplicationController
  include ResourceModule
  include AttachmentModule
  include Utils#, only: [:get_resource_by_id]
  public :get_resource_by_id # this makes available only the method :get_resource_by_id from Utils module
  before_action :authenticate_user!, except: [:show, :index, :fast_links, :super_school, :principal_speech, :serves_data]
  before_action :set_current_school, :common_config #, :set_current_scholastic_period
  before_action :constantize_model_service, only: [:index, :create, :table_header, :argument, :show, :update]
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from AttachmentHandler::AttachmentExceedLimitError, with: :overflow_attachment
  before_action :set_parent_model, only: [:index]

  #skip_before_action :authenticate_user!, only: [:show]
  
  # set resource parent of resource except school and theme
  def set_parent_model
    if ["events", "evaluations", "configure_activities", "evaluations","courses", "homeworks", "submissions"].include?(controller_name)
      if params[:record_type].present? && params[:record_id].present?
        # Both record_type and record_id parameters exist 
        model_class = string_to_model_class(params[:record_type])

        if model_class.nil?
          message = "#{params[:record_type]} is not associated with a model"
          error_message_with_flag(message, Flag::ERROR)
          return
        end
        @parent_model = model_class.find(params[:record_id])
      else
        # One or both of the parameters are missing
        message = I18n.t('activerecord.errors.controllers.event.record_type_id_must_exist')
        error_message_with_flag(message, Flag::ERROR)
      end
    elsif ["parents"].include?(controller_name)
      @parent_model = nil
    elsif !School.reflect_on_association(controller_name.to_sym).nil? || ["cycles"].include?(controller_name)
      @parent_model = current_school
    elsif !ScholasticPeriod.reflect_on_association(controller_name.to_sym).nil? 
        @parent_model = current_scholastic_period
    else
        @parent_model = root_school
    end
    @parent_model
  end


  # default pagination for all resources
  def page  
    #@page =  request.headers['page'] ? request.headers['page'].to_i : 1
    #@page =  params[:page] ? params[:page].to_i : 1
    @page ||= params.fetch(:page, 1).to_i
    
  end
  def per_page
    #@per_page = request.headers['per-page'] ? request.headers['per-page'].to_i : ENV.fetch('MAX_RECORD_PER_PAGE'){'25'}.to_i
    #@per_page = params[:per_page] ? params[:per_page].to_i : ENV.fetch('MAX_RECORD_PER_PAGE'){'25'}.to_i
    @per_page ||= params.fetch(:per_page, ENV.fetch('MAX_RECORD_PER_PAGE'){'25'}).to_i
  end

  def not_found
    mesg = I18n.t 'resource_not_found', scope: 'global'
    render json: {
      message: mesg,
      flag: Flag::WARMING
    }, status: 404
  end

  # render a message if the school in which a resource belongs to is not the same as the one received from front end
  def resource_not_belongs_to_school(school_denomination) # resource_name, 
    mesg = I18n.t 'resource_not_belongs_to_school', school_denomination: school_denomination, scope: 'global'  # , resource_name: resource_name,
    render json: {
      message: mesg,
      flag: Flag::WARMING
    }, status: :forbidden
  end

  def record_invalid(message)
    render json: {
      message: message,
      flag: Flag::WARMING
    }, status: 400
  end
  
  def overflow_attachment(message)
      #mesg = I18n.t 'overflow_attachment', resource_name: @resource.resource_name, limit_attachments: resource_name::LIMIT_ATTACHMENTS, scope: 'global'   
    render json: {
        message: message,
        flag: Flag::ERROR
      }, status: :ok
      nil
  end

  def error_message_with_flag(message, flag)
    render json: {
      message: message,
      flag: flag
    }, status: :ok
  end

  def root_school
    School.find_by_identification_number(School::SUPER_IDENTIFICATION_NUMBER)
  end
  def current_school
    @current_school
  end

  def current_school_id
    @current_school_id
  end

  def current_cycle
    @current_cycle
  end

  def current_cycle_id
    @current_cycle_id
  end
  

  
  def current_scholastic_period
    
      if @current_scholastic_period.nil?
        raise I18n.t('current_scholastic_period_cannot_be_nil', scope: "global") 
      else
        @current_scholastic_period
      end
  rescue => e
      error_message_with_flag(e.message, Flag::ERROR)
    
  end


  def current_scholastic_period_id
    @current_scholastic_period_id = current_scholastic_period.id
  end

  def original_data?
    @data_type == 'original'
  end

  # def default_admin_user
  #   User.with_role(:admin).first
  # end

  # def default_admin_user_id
  #   User.with_role(:admin).first.id
  # end
  # return 1, 2 or 3 according the filter
  def filter_to_activate
    if params[:foreground].present? && !params[:sidebar].present?
      1
    elsif !params[:foreground].present? && params[:sidebar].present?
      2
    elsif params[:foreground].present? && params[:sidebar].present?
      3
    else
      4
    end
  end
  # filter news/events by foreground/sidebar
  def filter_by_sidebar_forground(records, filter_to_activate)
    case filter_to_activate
    when 1  # filter by foreground only 
      records.where(foreground: params[:foreground])
    when 2 # filter by sidebar only
      records.where(sidebar: params[:sidebar])
    when 3 # filter by foreground and sidebar
      records.where(foreground: params[:foreground], sidebar: params[:sidebar])
    else # do not apply any filter
      records
    end
  end
  
  
  # filter news/events by date (from ..to) and by pattern in denomination ()
  def filter_by_to_from_term(records)
    #records = records.by_from(params[:from]).by_to(params[:to]).by_term(params[:term])
    records = records.by_from(params[:from]) if params[:from]
    records = records.by_to(params[:to]) if params[:to]
    records = records.by_common(params[:common]) if params[:common]
    records
  end
=begin 
  # get schools by user: based on the type of user the list of school is obtaing
  def get_schools
    
    if current_user.admin?
      schools = all_schools
    else
      case current_user.userable_type
        when "Student"
          student = current_user.userable
          enabled_school = student.enableSchool
          if enabled_school # there is a active school
            #enabled_school = enabled_schools[0] # it is suppose to be of lenght 1 since only one school is enabled at a particular moment              
            schools = School.where(id: enabled_school["school_id"]).includes([:monitoring])              
          else # The student has any active school
            # the student has any active school therefore all (past) schools should be returned
            schools = student.schools
          end
        when "Staff"
          # return employee school based on the type (principal, teacher, .....) 
        when "Parent"
        else
          # return all schools
      end
    end  
    schools
  end
=end
  def all_schools
    School.includes(:monitoring).by_non_deleted.order(:denomination)
  end
  # get all resources (used in the index method of some controllers)
  def set_resources(resource_name, to_includes=[])
    model = resource_name.camelize.constantize
    if resource_name.eql?("monitoring")
      defaut_to_includes = [] # the monitoring model is not monitored
    else
      defaut_to_includes = model.respond_to?(:translations) ? [:monitoring, :translations] : [:monitoring] # to change
    end
    # to_includes.concat(defaut_to_includes)
    to_includes = defaut_to_includes + to_includes
    @resources = current_school_id ? model.all.by_school([current_school_id, resource_name.pluralize, to_includes]) : model.all.includes(to_includes)
    if params[:status] # if the status is given filter the corresponding status
      status = params[:status].to_i
      @resources.by_status(status)
    else # otherwise filter by non deleted
      @resources.by_non_deleted
    end
  end
  


  # delete resources of a model from a list of record ids
  def delete_resources
    resource_name = params[:controller].split('/').last
    scope = "resource" + "." + "destroys"
    class_name = resource_name.singularize.camelize
    # Check if the class name is in the whitelist
    model = class_name.constantize #if ALLOWED_CLASSES.include?(class_name)
    begin
      @resources =  resource_name.eql?("schools") ? [] : model.where(id: params[:ids])
      if @resources.any?
        @resources.map{ |resource| update_delete_resource(resource, Constant::RESOURCE_METHODS[:delete], new_parameters = nil, { notRenderAfterUpdateDelete: true }) if  resource.monitoring.status != Status::DELETED}
        mesg = I18n.t('success', scope: scope, resource_name: resource_name)
        render json: {message: mesg, flag: Flag::SUCCESS}, status: :ok
      else
        mesg = I18n.t('warming', scope: scope, resource_name: resource_name)
        render json: {message: mesg, flag: Flag::WARMING}, status: :not_found
      end
    rescue => exception
      mesg = I18n.t('error', scope: scope, resource_name: resource_name)
      render json: {message: mesg, error_message: exception, flag: Flag::ERROR}, status: :internal_server_error
    end
  end
  
 
  # Organise resource per page
  def organize_per_page(records)
    return [] unless records
    if params[:page].present?
      records.page(page).per(per_page)
    else
     records
    end
  end
 
  def string_to_model_class(model_name)
    model_class = model_name.singularize.camelize.safe_constantize
  end 
  
  def service_name
    @service_name ||= Constant::SERVICES_NAMES.include?(params[:service_name]) ? params[:service_name] : Constant::SERVICES_NAMES[1]
  end


  private

  def constantize_model_service
    resource_name = controller_name.singularize.camelize
    @Resource = resource_name.constantize
    @ResourceService = (resource_name + "Service").constantize unless ["contacts", "monitorings", "configure_activities"].include?(controller_name) # for controllers that do not have services
    
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_current_school
    params[:school_id] ||= request.headers['X-school-id'] || nil
    return if params[:school_id].blank?
    @current_school_id = params[:school_id].to_i
    #@current_school = Rails.cache.fetch("current_school_#{@current_school_id}") do
      begin
        @current_school = School.find(@current_school_id)
      rescue Exception => ex
        render json: { message: ex, flag: Flag::ERROR}, status: :not_found
      end
    #end
  end

  def set_current_scholastic_period
    params[:scholastic_period_id] ||= request.headers['X-scholastic-period-id'] || @current_school&.current_scholastic_period&.id
    
    return if params[:scholastic_period_id].blank?
    # binding.pry
    unless current_school.super_school? || current_school.scholastic_period_ids.include?(params[:scholastic_period_id].to_i)
      error_message_with_flag("Scholastic period non in this school", Flag::ERROR)
      return
    end
  
    #@current_scholastic_period_id = params[:scholastic_period_id].to_i
    @current_scholastic_period = ScholasticPeriod.find_by(id: params[:scholastic_period_id].to_i)
  end

  def set_current_cycle
    params[:cycle_id] ||= request.headers['X-cycle-id']  || nil
    
    return if params[:cycle_id].blank?

    @current_cycle_id = params[:cycle_id].to_i
    
    begin
      @current_cycle = Cycle.find(@current_cycle_id)
    rescue Exception => ex
      render json: { message: ex, flag: Flag::ERROR }, status: :not_found
    end
  end

  def common_config
    @data_type ||= params[:resource_data_type].presence || request.headers['X-resource-data-type'].presence || 'table_data'
    params[:status] ||= request.headers['X-default-status'] if request.headers['X-default-status'].present?
    params[:service_name] ||= request.headers["X-service"].presence || Constant::SERVICES_NAMES[1]
  end
  
end