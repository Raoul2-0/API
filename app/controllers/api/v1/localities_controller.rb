class Api::V1::LocalitiesController < Api::V1::TablesController
  skip_before_action :authenticate_user!, only: [:countries, :regions, :cities] # :index, :show,

  # GET /localities/countries
  def countries
    language = params[:locale] || I18n.default_locale
    countries = ISO3166::Country.all.map do |country|
      {
        label: country.translations[language] || country.name,
        value: country.alpha2
      }
    end
    render json: sort_by_label(countries), status: :ok
  end

  # GET /localities/:country_code/regions
  def regions
    country_code = params[:country_code].upcase
    language = params[:locale] || I18n.default_locale
    country = ISO3166::Country[country_code]
    regions = country.subdivisions.map do |region|
      {
        label: region[1].translations[language],
        value: region[0]
      }
    end
    render json: sort_by_label(regions), status: :ok
  end

  #  GET localities/:country_code/cities
  def cities
    Cities.data_path = './cities'
    cities = Cities.cities_in_country(params[:country_code]).map do |city|
      {
        label: city[1].name,
        value: city[0]
      }
    end
    render json: cities, status: :ok
  end

  private 

  def sort_by_label(localities)
    localities.sort_by { |locality| locality[:label] }
  end

end
