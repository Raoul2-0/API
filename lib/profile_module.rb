module ProfileModule
  FILTERS = %w[common]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'profile'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'profiles' unless const_defined?(:DEFAULT_ARGUMENT)
end