require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { build_course() }

  it 'is valid with valid attributes' do
    expect(course).to be_valid
  end


  it 'is not valid without a denomination' do
    course.denomination = nil
    expect(course).to_not be_valid
  end

  it 'is valid without a description' do
    course.description = nil
    expect(course).to be_valid
  end

  it 'is not valid without a classroom' do
    course.classroom_id = nil
    expect(course).to_not be_valid
  end

  it 'is not valid without a scholastic_period' do
    course.scholastic_period_id = nil
    expect(course).to_not be_valid
  end

  it 'is not valid without a course generality' do
    course.course_generality_id = nil
    expect(course).to_not be_valid
  end

  it { should belong_to(:scholastic_period) }
  it { should belong_to(:classroom) }
  it { should belong_to(:course_generality) }

  it 'is valid with a report' do
    course.reports << build_report(course.id, "Course")
    expect(course).to be_valid
  end
end
