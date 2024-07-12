module ThemeModule
  LIMIT_ATTACHMENTS = {home_page: 1} unless const_defined?(:LIMIT_ATTACHMENTS) # limit the number of attachments for theme to 1
  FILTERS = %w[common]
  SORT_DEFAULT = "denomination"
  MODEL_NAME = 'theme'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'themes' unless const_defined?(:DEFAULT_ARGUMENT)
end