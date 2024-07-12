require 'faker'
require 'factory_bot_rails'

module EvaluationHelpers
  
  def create_evaluation_with_timing
    evaluation = handle_monitoring(FactoryBot.create(:evaluation, evaluation_parameters_without_timing))
    evaluation = add_timing_to_evaluation_payload(evaluation)
    evaluation.save
    evaluation
  end
  
  def create_evaluation_without_timing
    handle_monitoring(FactoryBot.create(:evaluation, evaluation_parameters_without_timing))
  end

  def evaluation_parameters_without_timing
    {
      evaluation_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
      denomination: Faker::Lorem.word,
      description: Faker::Lorem.paragraph,
      course_id: create_course.id,
      local_id: create_local.id
    }
  end

  def build_evaluation_with_timing
    evaluation = FactoryBot.build(:evaluation, evaluation_parameters_without_timing)
    evaluation = add_timing_to_evaluation_payload(evaluation)
    evaluation
  end

  def build_evaluation_without_timing
    FactoryBot.build(:evaluation, evaluation_parameters_without_timing)
  end

  def evaluation_payload_with_timing(evaluation, success=true)
    if success
      {
        evaluation_date: evaluation.evaluation_date,
        denomination: evaluation.denomination,
        description: evaluation.description,
        timing_attributes: {
          start_time: evaluation.timing.start_time,
          end_time: evaluation.timing.end_time
        },
        course_id: evaluation.course_id,
        local_id: evaluation.local_id
      }
    end
  end

  def add_timing_to_evaluation_payload(evaluation)
    timing = create_timing(evaluation)
    evaluation.timing = timing
    evaluation
  end

  def evaluation_payload_without_timing(evaluation, success=true)
    if success
      {
        evaluation_date: evaluation.evaluation_date,
        course_id: evaluation.course_id,
        local_id: evaluation.local_id
      }
    end
  end

  # Verify if all the attributes are updated
  def verify_all_evaluation_attributes_updated(new_evaluation, evaluation_saved)
    expect(evaluation_saved.evaluation_date).to eq(new_evaluation.evaluation_date)
    expect(evaluation_saved.course_id).to eq(new_evaluation.course_id)
    expect(evaluation_saved.local_id).to eq(new_evaluation.local_id)
  end
end
