require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'validations' do
    subject { FactoryBot.build(:report) }

    it { is_expected.to validate_presence_of(:denomination) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:reportable) }
  end
end
