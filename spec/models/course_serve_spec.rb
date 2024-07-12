require 'rails_helper'

RSpec.describe CourseServe, type: :model do
  it { should belong_to(:serve) }
  it { should belong_to(:course) }
end
