module CourseModule
  FILTERS = %w[common]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'course'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'courses' unless const_defined?(:DEFAULT_ARGUMENT)
  DECODE_LIST = [
    {cod: :subject, group_key: 'course_subject'},
    {cod: :coefficient, group_key: 'course_coef'}
  ]
end