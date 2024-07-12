require 'faker'
require 'factory_bot_rails'

module TableDescriptionHelpers
   def table_description_parameters
    {
		category: Faker::Alphanumeric.alpha(number: 10),
    description: Faker::Lorem.paragraph,     
	}
    end
	def create_table_description 
		handle_monitoring(FactoryBot.create(:table_description, table_description_parameters))
	end
	  
	def build_table_description
		FactoryBot.build(:table_description, table_description_parameters)
	end
end