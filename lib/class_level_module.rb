module ClassLevelModule
  FILTERS = %w[common]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'class_level'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'class_levels' unless const_defined?(:DEFAULT_ARGUMENT)
end