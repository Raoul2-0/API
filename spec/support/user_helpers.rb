require 'faker'
require 'factory_bot_rails'

module UserHelpers
   def user_parameters
    {
      email: Faker::Internet.email, 
      password: Faker::Internet.password,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      sex: Faker::Gender.binary_type,
      avatar_url: Faker::Internet.url,
      identification_number: (Faker::Alphanumeric.alphanumeric(number: Constant::USER_IDENTIFICATION_NUMBER_LENGTH, min_alpha: 5, min_numeric: 9)
                             ).upcase,
      birthday: {
        date: Faker::Date.between(from: 25.years.ago, to: 11.years.from_now),
        country: Faker::Address.country,
        city:Faker::Address.city
      }, # "birthday_street": Faker::Address.street_address
      phones: {
        phone_1: Faker::PhoneNumber.cell_phone_with_country_code, 
        phone_2: Faker::PhoneNumber.cell_phone_with_country_code, 
        landline: Faker::PhoneNumber.phone_number_with_country_code 
      },
      address: {
        country: Faker::Address.country, 
        region: Faker::Address.state, 
        city: Faker::Address.city, 
        street: Faker::Address.street_address,
        po_box: Faker::Address.postcode
      },
      email_confirmed:Faker::Boolean.boolean(true_ratio: 0.2) 
    }
   end
 
  def create_user
    FactoryBot.create(:user, user_parameters)
  end

  def create_admin_user
    user = FactoryBot.create(:user, user_parameters)
    user.set_as_admin
    user
  end
  
  def build_user
    FactoryBot.build(:user, user_parameters)
  end
  
end