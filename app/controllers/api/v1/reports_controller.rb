class Api::V1::ReportsController < Api::V1::TablesController
    before_action :set_resource, only: [:show, :update, :destroy]

    def set_parent_model
        @parent_model = get_resource_by_id(params[:reportable_id],params[:reportable_type])
    end

    private
  
        # Only allow a list of trusted parameters through.
        def resource_params
            params.permit(:reportable_type, :reportable_id, :denomination, :description)
        end
end
