module HomeworkModule
    FILTERS = %w[common start_date end_date]
    SORT_DEFAULT = "details_translations.denomination"
    MODEL_NAME = 'homework'
    TO_INCLUDES =[[detail: :translations], :translations]
    DEFAULT_ARGUMENT ='homeworks' unless const_defined?(:DEFAULT_ARGUMENT)  
    LIMIT_ATTACHMENTS = { files: 5 } unless const_defined?(:LIMIT_ATTACHMENTS)
end