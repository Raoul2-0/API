require 'rails_helper'


RSpec.describe Theme, :type => :model do
	let! (:theme) {build_theme}
  
  # a school has many monitorables
  context 'Validate monitorable' do
    it_behaves_like "monitorable"
  end
  
  context 'Validate presence of columns' do
    it { should have_db_column(:denomination).of_type(:string) }
    #it { should have_db_column(:image).of_type(:string) }
    it { should have_db_column(:colors).of_type(:jsonb) }  
    # it { is_expected.to have_many(:schools) }
    it { should have_many(:schools) }
  end
  
	context 'Validate  theme attributes' do
    it "is valid with valid attributes" do
        expect(theme).to be_valid
    end
    
    it "is not valid without a denomination" do
        theme.denomination = nil
        expect(theme).to_not be_valid
    end
    
    # it "is not valid without a image" do
    #     theme.image = nil
    #     expect(theme).to_not be_valid
    # end

    it "is not valid colors" do
      theme.colors = nil
      expect(theme).to_not be_valid
    end
  end
end