module CycleModule
  FILTERS = %w[]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'cycle'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'cycles' unless const_defined?(:DEFAULT_ARGUMENT)
end