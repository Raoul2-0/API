class Evaluation < ApplicationRecord
  include Monitorable
  include EvaluationModule
  include Timeable 
  include Reportable
  acts_as :detail
  belongs_to :course # an evaluation belongs to a course

  validates :evaluation_date, presence: true
  accepts_nested_attributes_for :timing
  validates :denomination, presence: true
  #accepts_nested_attributes_for :reports

  #has_one :evaluation_type # an evaluation must be associated with a type of evaluation
  has_one :decode_relations
  has_many :decodes, through: :decode_relations

  has_one :local # an evaluation is done in one local

  # connect evaluation and attend_scholastic_period
  has_many :attend_scholastic_period_evaluations
  has_many :attend_scholastic_periods, through: :attend_scholastic_period_evaluations
  # end connection

  scope :by_common, lambda { |term| where("lower(detail_translations.denomination) ILIKE ?", "%#{term}%")}
  #scope :by_evaluation_type, lambda { |ids| where(evaluation_type_id: ids)}

  #def evaluation_type
    #Decodes.where(id: evaluation_type_id).first
  #end

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

  def starting_time
    start_time.strftime("%H:%M")
  end
  def ending_time
    end_time.strftime("%H:%M")
  end

  def duration
    duration_in_seconds = end_time-start_time  #.abs.to_i
    # Convert seconds to a Time object
    duration_time = Time.at(duration_in_seconds)
    # Format the Time object as 'HH:MM:SS'
    formatted_duration = duration_time.utc.strftime('%H:%M:%S')
  end

  def day_time_slot_overlap?(evaluation_date_new, start_time_new, end_time_new)
    if evaluation_date_new == evaluation_date
      # If the days are the same check for time overlap
      time_slot_overlap?(start_time, end_time, adjust_date(start_time, start_time_new), adjust_date(end_time, end_time_new))
    else
      false # if the days are different there is not overlap
    end
  end

  # check if two slot time overlap
  def time_slot_overlap?(start_time_1, end_time_1, start_time_2, end_time_2)
    overlap = (start_time_1 <= end_time_2) && (end_time_1 > start_time_2)
    #overlap = ((end_time_1 < start_time_2) || (end_time_2 < start_time_1)) ? false : true
  end

  # move the date part of time1 to time2
  def adjust_date(time1, time2)
    # Extract the date part from 'time1' as a Date object
    date_part = time1.to_date
    # Convert 'time2' to a DateTime object to manipulate the date part
    #datetime2 = time2.to_datetime
    datetime2 = time2.in_time_zone(time1.time_zone)

    #Set the date part from 'time1' on 'time2'
    time2_with_same_date = datetime2.change(year: date_part.year, month: date_part.month, day: date_part.day)
  end
end
