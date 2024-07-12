require "#{Rails.root}/lib/utils"
include Utils
task :create_user => :environment do
  sign_up_params = {
   email: "ngum@gmail.com",
   password: "azerty12",
   first_name:"Manick",
   last_name: "Mbakop",
   sex: "male", 
   identification_number: ('A'..'Z').to_a.sample(Constant::USER_IDENTIFICATION_NUMBER_LENGTH).join,
   birthday: {
     date: (Date.current - 100).to_s,
     country: %w[Cameroun Angola Senegal Mali][rand(4)], 
     city: %w[Yaounde Douala Bafoussam Dschang][rand(4)],
   },
   phones: {
     phone_1: "+237" + (0..9).to_a.sample(8).join, 
     phone_2: "+237" + (0..9).to_a.sample(8).join, 
     landline:""
   },
   address: {
    country: %w[Cameroun Angola Senegal Mali][rand(4)], 
     region: %w[Ouest Centre Litoral Sud][rand(4)],
     city: %w[Yaounde Douala Bafoussam Dschang][rand(4)], 
     street: "Quartier 5",
     po_box: "218"
   }
}
  @user = User.new(sign_up_params)
  @user.save!
  @user.set_as_admin
  confirmation_token = @user.save_token("registration")
  update_monitor(@user, Constant::RESOURCE_METHODS[:create], { user: @user, monitor_attributes: { status: 4 } })
end