module ConfigureLocale
  # the following two functions define the local language
  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end
      
  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
      
  def default_url_options
    { locale: I18n.locale }
  end
end

      