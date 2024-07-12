#require 'faker'
#require 'factory_bot_rails'


module SchoolHelpers
  def create_root_school 
    school_params = {
      denomination: "SYSAIT",
      sub_denomination: "SYSTEM Afrik Information & Technology",
      identification_number: School::SUPER_IDENTIFICATION_NUMBER
    }
    
    @school = School.new(school_params)
    @school.save!(:validate => false)
    @school
  end


  def school_parameters
    @school = School.super_school
    @school = create_root_school if @school.nil?
    theme = create_theme
    # root_id: Faker::Number.unique.number,
    # parent_id: Faker::Number.unique.number,
    {
      root_id: @school.id,
      parent_id: @school.id,
      denomination: Faker::University.name,
      identification_number: (Faker::Alphanumeric.alphanumeric(number: Constant::SCHOOL_IDENTIFICATION_NUMBER_LENGTH)).upcase,
      contacts_info: {
        #address: {country: Faker::Address.country, "city": Faker::Address.city, 
        #"street": Faker::Address.street_address},
        # The address is not a jsonb ma a normal String
        email: Faker::Internet.email,
        address: Faker::Address.full_address,
        registration_number: (Faker::PhoneNumber).to_s,
        telephone_1: Faker::PhoneNumber.cell_phone_with_country_code,
        telephone_2: Faker::PhoneNumber.cell_phone_with_country_code,
        whatApp_number: Faker::PhoneNumber.cell_phone_with_country_code,
        mobile_phone: Faker::PhoneNumber.cell_phone_with_country_code
          },
      social_media: {facebook: Faker::Internet.url, 
                    google: Faker::Internet.url,
              linkedIn: Faker::Internet.url, 
              twitter: Faker::Internet.url, 
              youtube: Faker::Internet.url,
              instagram: Faker::Internet.url
          },
      sub_denomination: Faker::University.name,
      history:Faker::Lorem.paragraph,
      admission_generality: Faker::Lorem.paragraph,
      sub_description: Faker::Lorem.paragraph,
      terms_condition: Faker::Lorem.paragraph,
      privacy_policy: Faker::Lorem.paragraph,
      protocol: Faker::Lorem.paragraph,
      cookies_policy: Faker::Lorem.paragraph,
      social: Faker::Lorem.paragraph,
      theme_id: theme.id
	  }
  end
  
  # creates a school and  saves it to the database: the save the monitor
	def create_school(user=current_user) 
		handle_monitoring(FactoryBot.create(:school, school_parameters)) # handle_monitoring is defined in api_helper.rb
  end
   
  # builds a school without saving
	def build_school
		FactoryBot.build(:school, school_parameters)
	end

  # defines the payload when creating a school both sussessfullly and with failure
  def school_payload(school, success=true)
    if success
         {
          root_id: school.root_id, 
          parent_id: school.parent_id,
          identification_number: school.identification_number,
          denomination: school.denomination,
          sub_denomination: school.sub_denomination,
          contacts_info: school.contacts_info,
          social_media: school.social_media,
          admission_generality: school.admission_generality,
          history: school.history,
          sub_description: school.sub_description,
          terms_condition: school.terms_condition,
          privacy_policy: school.privacy_policy,
          protocol: school.protocol,
          cookies_policy: school.cookies_policy,
          social: school.social,
          theme_id: school.theme_id,
        #   attachments: {	  
        #   main_logo:  [fixture_file_upload('logo/logo.png', Constant::CONTENT_TYPE[:png])],		
        #   main_banner: [fixture_file_upload('banners/BIG_BG.jpg',Constant::CONTENT_TYPE[:jpg]), fixture_file_upload('banners/SMALL_BG.jpg',Constant::CONTENT_TYPE[:jpg])]  
        #  }
        attachments: {
          main_logo:  [{filename: "main_logo", url: "https://drive.google.com/uc?export=view&id=1fWAF1IheqLuoJJ8WK8HhJZTCjwSNp8a7", content_type: "image"}],
          main_banner: [{filename: "main_banner", url: "https://drive.google.com/uc?export=view&id=14PxFdY0795h8n0JyjeMdaLTgZyvDOKPt", content_type: "image"}]
        }
       }
      
    else
       {
        root_id: school.root_id, 
        parent_id: school.parent_id, 
        denomination: school.denomination,
        sub_denomination: school.sub_denomination,
        contacts_info: school.contacts_info,
        social_media: school.social_media,
        admission_generality: school.admission_generality,
        history: school.history,
      }
    end
  end

  # verify if all attachments are saved 
  def verify_school_attachment(response_json)
    expect(response_json["attachments"]["main_logo"]).not_to be_empty
    expect(response_json["attachments"]["secondary_logo"]).to be_empty
    expect(response_json["attachments"]["main_banner"]).not_to be_empty
    expect(response_json["attachments"]["secondary_banner"]).to be_empty
    expect(response_json["attachments"]["galery"]).to be_empty
  end
end