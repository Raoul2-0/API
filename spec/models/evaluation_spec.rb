require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  let(:evaluation) { build_evaluation_with_timing() }

  it 'is valid with valid attributes' do
    expect(evaluation).to be_valid
  end

  it 'is not valid without an evaluation_date' do
    evaluation.evaluation_date = nil
    expect(evaluation).to_not be_valid
  end

  it 'is not valid without a start_time' do
    evaluation.timing.start_time = nil
    expect(evaluation.timing).to_not be_valid
  end

  it 'is not valid without an end_time' do
    evaluation.timing.end_time = nil
    expect(evaluation.timing).to_not be_valid
  end

  it 'is not valid without a denomination' do
    evaluation.denomination = nil
    expect(evaluation).to_not be_valid
  end

  it 'is valid without a description' do
    evaluation.description = nil
    expect(evaluation).to be_valid
  end

  it 'is not valid without a course' do
    evaluation.course_id= nil
    expect(evaluation).to_not be_valid
  end

  it 'is valid without a local' do
    evaluation.local_id = nil
    expect(evaluation).to be_valid
  end

  it { should belong_to(:course) }

  it 'is valid with a report' do
    evaluation.reports << build_report(evaluation.id, "Evaluation")
    expect(evaluation).to be_valid
  end
end
