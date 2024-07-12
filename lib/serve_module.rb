module ServeModule
  FILTERS = %w[]
  SORT_DEFAULT = ""
  MODEL_NAME = 'serve'
  TO_INCLUDES = []
  DEFAULT_ARGUMENT = 'serves' unless const_defined?(:DEFAULT_ARGUMENT)
end