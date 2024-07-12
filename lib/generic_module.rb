module GenericModule
  LIMIT_ATTACHMENTS = { images: 1 } unless const_defined?(:LIMIT_ATTACHMENTS)
  FILTERS = %w[common page_name]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'generic'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'generics' unless const_defined?(:DEFAULT_ARGUMENT)
  GENERICS_TO_HIDE_COLUMNS = ['AdminFeatures', 'AdminWhyElearning']
end
