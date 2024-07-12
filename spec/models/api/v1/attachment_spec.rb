require 'rails_helper'

RSpec.describe Attachment, type: :model do
  # let! (:attachment) {build_attachment}
	# let! (:createAttachment) {create_attachment}

  context 'Validate presence of columns' do
    it { is_expected.to have_db_column(:category).of_type(:string) }
    it { is_expected.to have_db_column(:file_id).of_type(:integer) }
    it { is_expected.to have_db_column(:filename).of_type(:string) }
    it { is_expected.to have_db_column(:url).of_type(:string) }
    it { is_expected.to have_db_column(:content_type).of_type(:string) }

    it { is_expected.to have_db_column(:attachable_id).of_type(:integer) }
    it { is_expected.to have_db_column(:attachable_type).of_type(:string) }
  
    it { is_expected.to belong_to(:attachable) }
  end
  
	# context 'Validate  attachment attributes' do
  #   it "is valid with valid attributes" do
  #         expect(attachment).to be_valid
	#   end
  
	#   it "is not valid without a category" do
  #       attachment.category = nil
  #       expect(attachment).to_not be_valid
	#   end
    
  #   it "is not valid without a file_id" do
  #       attachment.file_id = nil
  #       expect(attachment).to_not be_valid
	#   end

  #     it "is not valid without file_name" do
  #       attachment.filename = nil
  #       expect(attachment).to_not be_valid
	#     end

  #     it "is not valid without url" do
  #       attachment.url = nil
  #     	expect(attachment).to_not be_valid
	#   	end

  #     it "is not valid without content_type" do
  #       attachment.content_type = nil
  #     	expect(attachment).to_not be_valid
	#   	end
  #   end


end
