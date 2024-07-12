module ExtraActivityModule
  LIMIT_ATTACHMENTS = {logo: 1, image_banner: 1} unless const_defined?(:LIMIT_ATTACHMENTS)
  FILTERS = %w[common category]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'extra_activity'
  TO_INCLUDES = [[detail: :translations], :translations, :configure_activities]
  DEFAULT_ARGUMENT = 'extra_activities' unless const_defined?(:DEFAULT_ARGUMENT)
end