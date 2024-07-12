class Api::V1::NewsLettersController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :set_news_letter, only: [:show, :update, :destroy]
  skip_before_action :constantize_model_service, only: [:index, :create, :table_header, :argument, :show, :update]

  # GET /news_letters
  def index
    @news_letters = set_resources("news_letter")
    @news_letters = filter_by_to_from_term(@news_letters)
    render json: organize_per_page(@news_letters)
  end

  # GET /news_letters/1
  def show
    show_resource(@news_letter)
  end

  # POST /news_letters
  def create
    temp_response = validate_email(params[:email]) 
    if temp_response['mesg']
      render json: temp_response
    else
      @news_letter = NewsLetter.new(news_letter_params)
      create_resource(@news_letter)
    end
  end

  # PATCH/PUT /news_letters/1
  def update
    update_delete_resource(@news_letter, Constant::RESOURCE_METHODS[:update], news_letter_params)
  end

  # DELETE /news_letters/1
  def destroy
    update_delete_resource(@news_letter, Constant::RESOURCE_METHODS[:delete])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_letter
      @news_letter = NewsLetter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def news_letter_params
      params.permit(:email)
    end

end
