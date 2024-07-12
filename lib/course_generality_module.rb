module CourseGeneralityModule
    FILTERS = %w[common start_date end_date]
    SORT_DEFAULT = "details_translations.denomination"
    MODEL_NAME = 'course_generality'
    TO_INCLUDES =[[detail: :translations], :translations]
    DEFAULT_ARGUMENT ='course_generalities' unless const_defined?(:DEFAULT_ARGUMENT)   #revoir l'orthographe de course_generalities 
end