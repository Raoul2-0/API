class Parent < ApplicationRecord
  include Monitorable
  include Userable
  include ParentModule
  translates :occupation

  # connect Parent to AttendScholasticPeriod
  has_many :children, class_name: 'AttendScholasticPeriod', foreign_key: 'parent1_id'
  has_many :children, class_name: 'AttendScholasticPeriod', foreign_key: 'parent2_id'
  # end connection

  def parent_attributes # attributes used in the serve serializer
    {
      id: id,
      occupation: occupation
    }
  end

  def user_attributes # attributes used in the student serializer
    default_user_attributes
  end

  def self.fetch_resources(params, parent_model, user)
    parameters = {
      parent_model: parent_model,
      to_includes: TO_INCLUDES,
      status: params[:status]
    }
    
    resources = set_resources(MODEL_NAME, parameters)
   
    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
    
    resources.reorder(sort)
  end
end
