module ClassroomModule
  FILTERS = %w[common cycle_id]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'classroom'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'classrooms' unless const_defined?(:DEFAULT_ARGUMENT)
end