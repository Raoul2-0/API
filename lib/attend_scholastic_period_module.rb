module AttendScholasticPeriodModule
  FILTERS = %w[common classroom]
  SORT_DEFAULT = ""
  TO_INCLUDES = []
  MODEL_NAME = 'attend_scholastic_period'
  DEFAULT_ARGUMENT = 'attend_scholastic_period' unless const_defined?(:DEFAULT_ARGUMENT)


  def general_infos
    {
      image: {
        url: avatar_url,
        fallback: initials,
      },
      rows: [
        { 
          name: 'Anagrafic',
          elements: [
            [{ value: 'fullname', translate: true }, { classes: 'text-bold', value: fullname(true) }],
            [{ value: 'identification_number', translate: true }, { value: identification_number }],
            [{ value: 'registration_number', translate: true }, { value: registration_number }],
            [{ value: 'email', translate: true }, { value: email }],
            [{ value: 'all_phones', translate: true }, { value: all_phones }],
            [{ value: 'classroom_denomination', translate: true }, { value: classroom_denomination }],
            [{ value: 'birthdate', translate: true }, { value: "#{birthdate}(#{gender})" }],
            [{ value: 'repeating', translate: true }, { value: repeating }]
          ]
        },
        {
          name: 'Contacts',
          elements: [
            [{ value: 'complete_address', translate: true }, { value: complete_address }],
            [{ value: 'enrollment_date', translate: true }, { value: "#{enrollment_date}(#{enrollment_status})" }],
            [{ value: 'parent_fullname', translate: true }, { value: parent_fullname }],
            [{ value: 'parent_email', translate: true }, { value: parent_email }],
            [{ value: 'parent_all_phones', translate: true }, { value: parent_all_phones }]
          ]
        }
# [
#           [{ value: 'parent_fullname', translate: true }, { value: parent_fullname }],
#           [{ value: 'parent_email', translate: true }, { value: parent_email }],
#           [{ value: 'parent_all_phones', translate: true }, { value: parent_all_phones }],
#           #[{ value: 'parent_complete_address', translate: true }, { value: parent_complete_address }]
#         ] 
      ]
    }
  end
end