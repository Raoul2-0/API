class ExtraActivitySerializer < BaseSerializer
  include AttachmentModule
  include Utils
  attributes :id, :school_id, :category, :denomination, :description, :meeting, :rule, :organigram, :preferences, :attachments, :ordinary_members, :office_members
  #has_many :configure_activities, serializer: ConfigureActivitySerializer
  #has_many :manifestations

  def meeting
    object.get_configuration("meeting",scope[:current_school_id])
  end
  def rule 
    object.get_configuration("rule",scope[:current_school_id])
  end
  def organigram
    object.get_configuration("organigram",scope[:current_school_id])
  end

  def ordinary_members
    object.filter_resources(object.activity_students.where(position: Constant::EXTRA_ACTIVITY_MEMBER_TYPE[:ordinary])).map { |activity_student| object.transform(activity_student) }
  end

  def  office_members
    #office =  activities.select { |activity_student| is_office_member?(activity_student)}
    object.filter_resources(object.activity_students.where.not(position: Constant::EXTRA_ACTIVITY_MEMBER_TYPE[:ordinary])).map { |activity_student| object.transform(activity_student) }
  end
end
