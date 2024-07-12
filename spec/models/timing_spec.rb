require 'rails_helper'

RSpec.describe Timing, type: :model do
  describe 'validations' do
    subject { FactoryBot.build(:timing) }

    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:timeable) }
  end
end
