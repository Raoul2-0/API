require 'rails_helper'



RSpec.describe School, :type => :model do
  let! (:admin_user) { create_admin_user }
	let! (:school) { build_school }
	let! (:createdSchool) { create_school(admin_user)}

 
  
  # context 'Validate presence of columns' do
  #   it { should have_db_column(:schoolable_id).of_type(:integer) }
  #   it { should have_db_column(:schoolable_type).of_type(:string) }
  
  #   it { should belong_to(:schoolable) }
  
  #  end
       
  # context 'Validate presence' do    
  #   it { should have_many(:news) }
  #   it { should have_many(:extra_activities) }
  #   it { should belong_to(:theme) }
  # end
 

  # a school has many attachables
  # context 'Validate attachable' do
  #   it_behaves_like "attachable"
  # end
   
  # a school has many monitorables
  # context 'Validate monitorable' do
  #   it_behaves_like "monitorable"
  # end
	context 'Validate  school attributes' do
      it "is valid with valid attributes" do
        expect(school).to be_valid
	    end
  
	    it "is not valid without a id parent" do
        school.parent_id = nil
        expect(school).to_not be_valid
	    end
    
      # it "is not valid without a denomination" do
      #   school.denomination = nil
      #   expect(school).to_not be_valid
	    # end


      # it "is not valid without a sub denomination" do
      #   school.sub_denomination = nil
      #   expect(school).to_not be_valid
	    # end

	    # it "is not valid without a contact" do
      #   school.contacts_info= nil
      #   expect(school).to_not be_valid
	    # end
  
	    # it "is not valid without social_media" do
      #   school.social_media = nil
      #   expect(school).to_not be_valid
	    # end

      # it "is not valid without the identification number" do
      #   school.identification_number = nil
      #   expect(school).to_not be_valid
      # end

      # it "is not valid if the length of the identification number is wrong" do
      #   min = Constant::SCHOOL_IDENTIFICATION_NUMBER_LENGTH + 1
      #   max = min + 1000
      #   school.identification_number = Faker::Alphanumeric.alphanumeric(number: Faker::Number.within(range: min..max)).upcase
      #   expect(school).to_not be_valid
      # end
	end
end