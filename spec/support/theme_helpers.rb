
module ThemeHelpers
  def theme_parameters
     {
       denomination: Faker::Alphanumeric.alpha(number: 10),
       colors: {
         black: "#000000",
         white: "#ffffff",
         primary: "#007b80",
         secondary: "#7FFF00",
         grey_variant_1: "#ebebeb",
         black_variant_1: "#595959",
         primary_variant_1: "#003a3c",
         primary_variant_2: "#00aaaf",
         primary_variant_3: "#1ce7ee",
         primary_variant_4: "#344749",
         primary_variant_5: "#1f2b2c"   
       }, 
    }
 end
 
 # create a theme and save it with the corresponding monitor
 def create_theme
   handle_monitoring(FactoryBot.create(:theme, theme_parameters))
 end
 
 # build a theme without saving
 def build_theme
   FactoryBot.build(:theme, theme_parameters)
 end
 # defines the payload when creating a theme both sussessfullly and with failure
 def theme_payload(theme, number_attachments=1, success=true)
   # theme_temp =  { 
   #   denomination: theme.denomination,
   #   colors: theme.colors
   #  }
   if success
     case number_attachments
       when 1
         {
           denomination: theme.denomination,
           colors: theme.colors,
           #  attachments: {	  
           #   home_page:  [fixture_file_upload('themes/theme1.jpg', Constant::CONTENT_TYPE[:jpg])],		
           # }
           attachments: {
             home_page:  [{filename: "Teal_green", url: "https://drive.google.com/uc?export=view&id=1iDUophAFqS_4ekJEZU1g2jQ5ZvsBLQ2Q", content_type: "image"}],
           }
         }
       
       when 2
         {
           denomination: theme.denomination,
           colors: theme.colors,
           #  attachments: {	  
           #   home_page:  [fixture_file_upload('themes/theme1.jpg', Constant::CONTENT_TYPE[:jpg]), fixture_file_upload('themes/theme2.jpg', Constant::CONTENT_TYPE[:jpg])],	# the name of the last file must be different from the others	
           # }
           attachments: {
             #theme1: [{filename: "theme 1", url: "https://drive.google.com/uc?export=view&id=1h3iwMOw7WxFOZIf1bkjeR5KaItUOCmK1", content_type: "image"}],
             home_page:  [{filename: "Teal_green", url: "https://drive.google.com/uc?export=view&id=1iDUophAFqS_4ekJEZU1g2jQ5ZvsBLQ2Q", content_type: "image"}]
           }
         }
     end
   end
 end
 
 # Verify if all the attributes are saved after creating a the
 def verify_all_theme_attributes_created(success=true)
   case success
    when true
     expect(response_json["denomination"]).to eq(theme.denomination)
     expect(response_json["colors"]).to eq(theme.colors)
   end
 end

 # Verify if all the attributes are updated
 def verify_all_theme_attributes_updated()
   expect(theme_saved.denomination).to eq(theme.denomination)
 end

end