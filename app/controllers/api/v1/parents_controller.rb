class Api::V1::ParentsController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]
  
  #PATCH/PUT /Parents/1
  def update
    if params[:user_attributes]
      update_delete_resource(@user, Constant::RESOURCE_METHODS[:update], user_params, { notRenderAfterUpdateDelete: true }) if !performed?
    end
    super
  end
  private

    def resource_params
      params.permit(:id, :occupation)
    end

    def user_params
      params.require(:user_attributes).permit(
        :first_name, :last_name, :sex, :email, :identification_number, :is_admin, birthday: [:date, :country, :city], phones: [:phone_1, :phone_2, :landline], address: [:country, :region, :city, :street, :po_box], preferences: [:school_id])
    end
end
