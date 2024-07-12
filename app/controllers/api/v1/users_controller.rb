class Api::V1::UsersController < Api::V1::TablesController
  skip_before_action :constantize_model_service, only: [:index, :create, :table_header, :argument, :show, :update] # will be removed when we will define a user service
  include UserModule
  # necessary to avoid  requests with the following body {'user': {...}}
  wrap_parameters :user, include: [:password, :email, :first_name, :last_name, :sex, :email_confirmed, birthday: [:date, :country, :city, :birthday_street], phones: [:phone_1, :phone_2, :landline], address: [:country, :city, :street]]
  before_action :set_user, only: [:show, :destroy, :add_role, :remove_role, :get_user_roles, :update, :refresh_token, :create_permissions, :permissions, :edit_permissions]
  # before_action :set_user_role, only: %w[add_role, remove_role]
  before_action :set_user_by_identification_number, only: [:show_by_identification_number]

  # GET /users
  def index
    #@users = set_resources("user").by_last_first_name
    @users = User.by_last_first_name
    render json: organize_per_page(@users), status: :ok
  end
      
  # GET /users/:id
  def show
    show_resource(@user)
  end

  # GET /users/:identification_number
  def show_by_identification_number
    show_resource(@user_by_identification_number)
  end

  # PATCH /users/:id/
  def update
    #binding.pry
    if @user
      #params[:user].delete(:password) if params[:user][:password].blank?
      
      begin
        @user.update!(user_params)
      rescue ActiveModel::ValidationError
        render json: {message: @user.errors, flag: Flag::ERROR}, status: :internal_server_error
      else
        mesg = I18n.t('users.update.success', user: I18n.t('user').capitalize)
        if request.headers['isLogedUser'] == "true" # this should be discussed with the front end
          render json: {message: mesg, token: token_refresh(@user), flag: Flag::SUCCESS}, status: :ok
        else
          render json: {message: mesg, flag: Flag::SUCCESS}, status: :ok
        end 
      end
    else
      mesg = I18n.t('users.unknown')
      render json: {message: mesg, flag: Flag::WARMING}, status: :ok # to fix
    end  
  end  

  # destroy a user
  def destroy
    @user_to_delete = params.has_key?(:id_user) ? get_user_by_id(params[:id_user]): @user
    allowed = false
    if params.has_key?(:id_user)
      if @user.has_role? :admin
        allowed = true
      end
    else
      allowed = true
    end
    if request.headers['destroy'] == "true"
      # Permanent deletion
      if allowed
        if @user_to_delete.destroy
          mesg = I18n.t('users.destroy.soft_deletion')
          render json: { message: mesg, flag: Flag::SUCCESS}, status: :ok
        else
          mesg = I18n.t('users.destroy.error')
          render json: { message: mesg, flag: Flag::ERROR}, status: :unprocessable_entity
        end
      else
        mesg = I18n.t('users.destroy.warning')
        render json: { message: mesg, flag: Flag::WARMING}, status: :unauthorized # to fix
      end
    else
      # soft deletion. Does not permanently delete the user
      if allowed
        @user_to_delete.update(deleted: true)
        if @user_to_delete.save
          mesg = I18n.t('users.destroy.soft_deletion')
          render json: { message: mesg, flag: Flag::SUCCESS}, status: :ok
        else
          mesg = I18n.t('users.destroy.error')
          render json: { message: mesg, flag: Flag::ERROR}, status: :internal_server_error
        end
      else
        mesg = I18n.t('users.destroy.warning')
        render json: { message: mesg, flag: Flag::WARMING}, status: :not_found
      end
    end
  end

  # GET /users/user_home
  def user_home
    resp = current_user.user_home(current_school_id, current_scholastic_period_id)

    render json: resp, status: :ok
  end

  # This method generates a new token to refresh the session of a new user
  # GET /users/:id/refresh_token
  def refresh_token
    if @user.nil?
      mesg = I18n.t('users.unknown')
      render json: {message: mesg, flag: Flag::WARMING}, status: :not_found 
    else
      bearer_token = token_refresh(@user)
      render json: {bearer_token: bearer_token}, status: :ok
    end
    
  end

  # POST /confirmation
  # validates an email after creation
  def confirmation
    user = User.find_by_confirmation_token(params[:params][:confirmation_token])
     if user
         user.validate_email
         user.save(validate: false)
         mesg = I18n.t 'registrations.emailConfirmed'
         render json: { message:  mesg, flag: Flag::SUCCESS}, status: :ok
     else
         mesg = I18n.t 'registrations.emailAlreadyConfirmed'
         render json: { message: mesg, flag: Flag::WARMING}, status: :found # if flag=2 => the mail is already confirmed
     end 
  end

  # #This method adds a role to a user
  #  POST /users/:id/add_role
  def add_role
    #binding.pry
    manage_role("add", @user)
  end
 
  # This method removes a role to a user
  # POST /users/id/remove_role
  def remove_role
    manage_role("remove", @user)
  end
  
  # This method returns all the available roles in the roles table
  # GET  v1/users/get_all_roles
  def get_all_roles
    @roles= Role.all # return and array of objects
    @roles= Role.all.pluck(:name)
    render json: @roles
  end


  # This method returns all the available roles for a particular user
  # GET /users/:id/get_user_roles
  def get_user_roles
    @roles = @user.roles.pluck(:name)
    render json: @roles
  end
  
  # GET  /school_preferences
  def school_preferences
    @school_preferences = current_user.get_school_preferences
    render json: @school_preferences
  end


  def create_permissions
    @user.roles.destroy_all
    #binding.pry
    @user.create_permissions(current_school_id)
    permissions
  end

  # GET id:/permissions
  def permissions
    render json: @user.user_permissions_in_school(current_school_id)
  end

  # POST /edit_permissions
  def edit_permissions
    if params["user_id"]
      @user.edit_permissions_in_school(current_school_id, model = params[:model], params[:permissions])
    end
    
    permissions
  end

  #  # get all the permissions associated to a specific role
  #  def permissions_for_role
  #   roles = @user.roles
  #   #get_permissions
  #   permissions = roles.map do |role|
  #     get_permissions.select(:name).where(role: role.name).pluck(:name)
  #   end.flatten.uniq
  #   render json: { user_id: user.id, roles: roles.map(&:name), permissions: permissions }
  # end

  private

  def set_user_by_identification_number
    @user_by_identification_number = Rails.cache.fetch("user_#{params[:identification_number]}") do
     User.find_by_identification_number(params[:identification_number])
    end
    @user_by_identification_number
  end

  def set_user
    #@user = User.find(params[:id])
    #@user = get_user_by_id(params[:id])
    user_id = params[:id] || params[:user_id]
    @user = get_resource_by_id(user_id,"user")
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :sex, :email, :identification_number, :is_admin, birthday: [:date, :country, :city], phones: [:phone_1, :phone_2, :landline], address: [:country, :region, :city, :street, :po_box], preferences: [:school_id])
  end

end