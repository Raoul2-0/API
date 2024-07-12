class Api::V1::GenericsController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]
  before_action :set_generics, only: [:fast_links]
  

  # GET /generics/fast_links
  def fast_links
    @generics = @generics.by_on_fast_link
    page_names = @generics.pluck(:page_name).uniq
    response = {}
    page_names.each { |page_name|
      fast_links = self.filter_resources(@generics.by_page_name(page_name))
      response[page_name.to_sym] = JSON.parse(ActiveModelSerializers::SerializableResource.new(fast_links, each_serializer: GenericSerializer).to_json)
    }
    render json: response
  end


  private
 
  # set generics for fast_links
  def set_generics
    constantize_model_service
    set_parent_model
    @generics = @Resource.fetch_resources(params, @parent_model, current_user)
  end

  # Only allow a list of trusted parameters through.
  def resource_params
    params.permit(:denomination, :description, :orientation, :page_name, :on_menu, :on_home, :on_fast_link)
  end
end
