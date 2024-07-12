require 'rails_helper'

describe Api::V1::ThemesController, type: :request do
  let! (:user) { create_user }
  let! (:admin_user) { create_admin_user }
  let! (:root_school_saved) { create_root_school }
	let! (:theme) { build_theme }
  let! (:theme_saved) { create_theme }
  
  
  # add a theme with one attachment. Normal condition
	context 'When creating a theme with one attachment' do
		before do
      perform_request(user=admin_user,end_point="/api/v1/themes/", payload=theme_payload(theme), school=nil, method="post", institutionalisable=false) 
		end
    it_behaves_like 'Shareable', {context:"creation_successful", model_name:"theme",execute_query: false}
    it 'should verify if all the attributes are created' do
			verify_all_theme_attributes_created()
		end
	end
  
  # add a theme with two attachments. Anormal condition
  context 'When creating a theme with more than one attachment only the last must be saved' do
		before do
      perform_request(user=admin_user,end_point="/api/v1/themes/", payload=theme_payload(theme, number_attachments=2), school=nil, method="post", institutionalisable=false)
		end
    it_behaves_like 'Shareable', {context:"creation_successful", model_name:"theme",execute_query: false}

		it 'should only save the last attachment' do 
      payload=theme_payload(theme, number_attachments=2)
      expect(response_json["attachments"]["home_page"].first["filename"]).to eq(payload[:attachments][:home_page].last[:filename])
      expect(response_json["attachments"]["home_page"].first["url"]).to eq(payload[:attachments][:home_page].last[:url])
      expect(response_json["attachments"]["home_page"].first["content_type"]).to eq(payload[:attachments][:home_page].last[:content_type])
		end
	end
  
	context 'When updating an inexisting theme' do
    before do
      perform_request(user=admin_user,end_point="/api/v1/themes/#{-1}", payload=Constant.set_payload({denomination: theme.denomination}), school=nil, method="put")
      #Constant.set_payload({denomination: theme.denomination})
     end
    it_behaves_like 'Shareable', {context:"failure", model_name:"theme",execute_query: false}
    #it_behaves_like 'Shareable', {endpoint:"/api/v1/themes/#{-1}", method:"put", context:"failure", model_name:"theme"}
  end
  
  context 'When updating an existing theme' do
		before do
      payload = { denomination: theme.denomination}
      perform_request(user=admin_user,end_point="/api/v1/themes/#{theme_saved.id}", payload=payload, school=nil, method="patch")
      theme_saved.reload
		end
    it_behaves_like 'Shareable', {context:"update_successful", model_name:"theme",execute_query: false}
    it 'should verify if all the attributes are updated' do
			verify_all_theme_attributes_updated()
		end
	end

  context 'when an ordinary user wants to delete a theme' do
		before do
      perform_request(user,end_point="/api/v1/themes/#{theme_saved.id}",payload=nil, school=nil, method="delete")
		end
    it_behaves_like 'Shareable', {context:"unauthorized", model_name:"theme",execute_query: false}
	end

  context 'when an admin_user wants to delete a theme' do
		before do
      Constant.set_resource(theme_saved)
      perform_request(admin_user,end_point="/api/v1/themes/#{theme_saved.id}",payload=nil, school=nil, method="delete")
    end
    it_behaves_like 'Shareable', {context:"delete_successful", model_name:"theme",execute_query: false}
	end
end