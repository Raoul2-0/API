module ReportModule
    LIMIT_ATTACHMENTS = { images: 5 } unless const_defined?(:LIMIT_ATTACHMENTS)
    FILTERS = %w[reportable_type]
    SORT_DEFAULT = "detail_translations.denomination"
    MODEL_NAME = 'report'
    TO_INCLUDES = [[detail: :translations], :translations]
    DEFAULT_ARGUMENT = 'reports' unless const_defined?(:DEFAULT_ARGUMENT)
end