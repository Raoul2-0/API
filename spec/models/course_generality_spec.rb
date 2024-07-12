require 'rails_helper'

RSpec.describe CourseGenerality, type: :model do
  
  let(:course_generality) {build_course_generality}

  it 'is valid with valid attributes' do
    expect(course_generality).to be_valid
  end

  it 'is not valid without a denomination' do
    course_generality.denomination = nil
    expect(course_generality).to_not be_valid
  end

  it 'is valid without a description' do
    course_generality.description = nil
    expect(course_generality).to be_valid
  end

  it 'is not valid without a duration' do
    course_generality.duration= nil
    expect(course_generality).to_not be_valid
  end
end
