module SubmissionModule
    FILTERS = %w[common start_date end_date]
    SORT_DEFAULT = "details_translations.denomination"
    MODEL_NAME = 'submission'
    TO_INCLUDES =[[detail: :translations], :translations]
    DEFAULT_ARGUMENT ='submissions' unless const_defined?(:DEFAULT_ARGUMENT)   
end