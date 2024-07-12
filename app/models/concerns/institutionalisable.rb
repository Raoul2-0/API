module Institutionalisable
  extend ActiveSupport::Concern

  included do
    has_many :institutions
    #has_many :evaluations, through: :institutions, source: :institutionalisable, source_type: 'Evaluation'
    #has_many :courses, through: :institutions, source: :institutionalisable, source_type: 'Course'
    #has_many :cycles, through: :institutions, source: :institutionalisable, source_type: 'Cycle'
    has_many :decode_configurations, through: :institutions, source: :institutionalisable, source_type: 'DecodeConfiguration'
    has_many :news, through: :institutions, source: :institutionalisable, source_type: 'News'
    has_many :extra_activities, through: :institutions, source: :institutionalisable, source_type: 'ExtraActivity'
    #has_many :events, through: :institutions, source: :institutionalisable, source_type: 'Event'
    has_many :contacts, through: :institutions, source: :institutionalisable, source_type: 'Contact'
    #has_many :statistics, through: :institutions, source: :institutionalisable, source_type: 'Statistic'
    has_many :generics, through: :institutions, source: :institutionalisable, source_type: 'Generic'
    has_many :collaborators, through: :institutions, source: :institutionalisable, source_type: 'Collaborator'
    has_many :monitorings, through: :institutions, source: :institutionalisable, source_type: 'Monitoring'
    #has_many :users, through: :institutions, source: :institutionalisable, source_type: 'User'
    has_many :scholastic_periods, through: :institutions, source: :institutionalisable, source_type: 'ScholasticPeriod'
    has_many :news_letters, through: :institutions, source: :institutionalisable, source_type: 'NewsLetter'
    has_many :configure_activities, through: :institutions, source: :institutionalisable, source_type: 'ConfigureActivity'
    has_many :galleries, through: :institutions, source: :institutionalisable, source_type: 'Gallery'
    has_many :locals, through: :institutions, source: :institutionalisable, source_type: 'Local'
    has_many :evaluation_types, through: :institutions, source: :institutionalisable, source_type: 'EvaluationType'
    has_many :class_levels, through: :institutions, source: :institutionalisable, source_type: 'ClassLevel'
    has_many :classrooms, through: :institutions, source: :institutionalisable, source_type: 'Classroom'
    has_many :departments, through: :institutions, source: :institutionalisable, source_type: 'Department'
    #has_many :jobs, through: :institutions, source: :institutionalisable, source_type: 'Job'
    has_many :profiles, through: :institutions, source: :institutionalisable, source_type: 'Profile'
    has_many :course_generalities, through: :institutions, source: :institutionalisable, source_type: 'CourseGenerality'
    
  end
end