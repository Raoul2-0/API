require 'rails_helper'

RSpec.describe User, :type => :model do
  let! (:user) { build_user }
  let! (:createdUser) { create_user }

  # a User has many monitorables
  context 'Validate monitorable' do
    it_behaves_like "monitorable"
  end
  
  # validate presence of attributes
  context 'Validate presence of columns' do
    # useful columns
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:encrypted_password).of_type(:string) }
    it { should have_db_column(:first_name).of_type(:string) }
    it { should have_db_column(:last_name).of_type(:string) }
    it { should have_db_column(:sex).of_type(:string) }
    it { should have_db_column(:identification_number).of_type(:string) }

    it { should have_db_column(:birthday).of_type(:jsonb) } 
    it { should have_db_column(:phones).of_type(:jsonb) }
    it { should have_db_column(:address).of_type(:jsonb) }

    # management Columns
    # it { should have_db_column(:email_confirmed).of_type(boolean) } to remove on local db
    it { should have_db_column(:confirmation_token).of_type(:string) }
    it { should have_db_column(:confirmation_sent_at).of_type(:datetime) }
    it { should have_db_column(:confirmed_at).of_type(:datetime) }

    #it { should have_many(:schools) }
    #boolean colomns
    it { should have_db_column(:disabled).of_type(:boolean) }
  end
 
  # validate user attribute
  context 'Validate  user attributes' do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is not valid without a email" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "is not valid without a password" do
      user.password = nil
      expect(user).to_not be_valid
    end

    it "is not valid without the first_name" do
      user.first_name = nil
      expect(user).to_not be_valid
    end
      
    it "is not valid without the last_name" do
      user.last_name = nil
      expect(user).to_not be_valid
    end

    it "is not valid without the last_name" do
      user.last_name = nil
      expect(user).to_not be_valid
    end

    it "is not valid without the sex" do
      user.sex = nil
      expect(user).to_not be_valid
    end

    it "is not valid without the birthday" do
      user.birthday = nil
      expect(user).to_not be_valid
    end

    it "is not valid without the phones" do
      user.phones = nil
      expect(user).to_not be_valid
    end

    it "is not valid without the address" do
      user.address = nil
      expect(user).to_not be_valid
    end

    it "is not valid without the identification number" do
      user.identification_number = nil
      expect(user).to_not be_valid
    end

    it "is not valid if the length of the identification number is wrong" do
      min = Constant::USER_IDENTIFICATION_NUMBER_LENGTH + 1
      max = min + 1000
      user.identification_number = Faker::Alphanumeric.alphanumeric(number: Faker::Number.within(range: min..max)).upcase
      expect(user).to_not be_valid
    end

    # it "is not valid without the email_confirmed" do
    #   user.email_confirmed = nil
    #   expect(user).to_not be_valid
    # end

   
  end

  context 'When adding a role to a user, ' do
    it "it does not add the role if it already exists" do
      createdUser.add_role(:role)
      expect(createdUser.add_new_role(:role)).to eq(false)
    end
    it "add a role if it does not exist" do
      expect(createdUser.add_new_role(:role)).to eq(true)
    end
  end

  context 'When save password reset expiry date' do
    it 'should set a deadline of 24 hours' do
      currentTime = createdUser.save_password_reset_expiry_date!
      expect(User.find_by_id(createdUser.id)[:password_reset_expiry_date].to_datetime.minute).to eq((currentTime + Constant::RESET_PASSWORD_DEADLINE).minute)
    end
  end

end