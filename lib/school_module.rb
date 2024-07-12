module SchoolModule
  unless const_defined?(:LIMIT_ATTACHMENTS)
    SINGLE_ATTACHMENTS_EQUIRED = { main_logo: 1, main_banner: 1 }
    SINGLE_ATTACHMENTS = SINGLE_ATTACHMENTS_EQUIRED.merge({ 
      secondary_logo: 1, 
      secondary_banner: 1,
      staff_banner: 1, 
      admission_banner: 1, 
      enrollment_banner: 1, 
      orientation_banner: 1, 
      pedagogy_banner: 1, 
      about_banner: 1,
      events_banner: 1,
      news_banner: 1,
      contacts_banner: 1,
      cookies_banner: 1,
      feedbacks_banner: 1,
      gallery_banner: 1,
      privacy_banner: 1,
      protocol_banner: 1,
      social_banner: 1,
      structures_banner: 1,
      tenders_banner: 1,
      terms_banner: 1,
      rules_banner: 1,
      organigram_banner: 1,
      organigram: 1
    })
    MULTIPLE_ATTACHMENTS = { galery: 20 }
    LIMIT_ATTACHMENTS = SINGLE_ATTACHMENTS.merge(MULTIPLE_ATTACHMENTS)
  end

  FILTERS = %w[common] unless const_defined?(:FILTERS)
  SORT_DEFAULT = "schools.denomination" unless const_defined?(:SORT_DEFAULT)
  DEFAULT_ARGUMENT = 'schools' unless const_defined?(:DEFAULT_ARGUMENT)
  SUPER_IDENTIFICATION_NUMBER = "00000000000" unless const_defined?(:SUPER_IDENTIFICATION_NUMBER)
end
