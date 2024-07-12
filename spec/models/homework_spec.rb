require 'rails_helper'

RSpec.describe Homework, type: :model do
  let!(:admin_user) { create_admin_user }
  let!(:school) { create_school(admin_user) }
  let!(:serve) { create_serve(school) }
  let!(:course) { create_course(school, admin_user) }
  let!(:homework) { build_homework(serve,course) }

  describe 'associations' do
    it { should belong_to(:serve) }
    it { should have_many(:submissions)}

  end
  describe 'validations' do
    it { should validate_presence_of(:denomination)}
    it { should validate_presence_of(:description)}
    it do
      should validate_inclusion_of(:optional).
      in_array([true,false])
    end
    it 'is valid with valid attributes' do
      expect(homework).to be_valid
    end
    it 'is not valid without a optional' do
      homework.optional= nil
      expect(homework).to_not be_valid
    end
  end
  
end
