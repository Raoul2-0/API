require 'rails_helper'

describe Api::V1::AttachmentsController, type: :request do
  # let! (:admin_user) { create_admin_user }
  # let! (:school) { create_school }
  # context 'When adding attachments to the schools table' do
  #   # parameters = {
  #   #   "model": "School",	
  #   #   "record_id": school.id,	
  #   #   attachments: {	  
  #   #     "logo":  [fixture_file_upload('logo.png', Constant::CONTENT_TYPE[:png])],		
  #   #     "banner": [fixture_file_upload('BIG_BG.jpg',Constant::CONTENT_TYPE[:jpg]), fixture_file_upload('SMALL_BG.jpg',Constant::CONTENT_TYPE[:jpg])]  
  #   #   }
	# 	before do
	# 		login_with_api(admin_user)
  #       	post "/api/v1/attachments/add_files",params: {
  #         "model": "School",	
  #         "record_id": school.id,	
  #         attachments: {	  
  #           "logo":  [fixture_file_upload('logo.png', Constant::CONTENT_TYPE[:png])],		
  #           "banner": [fixture_file_upload('BIG_BG.jpg',Constant::CONTENT_TYPE[:jpg]), fixture_file_upload('SMALL_BG.jpg',Constant::CONTENT_TYPE[:jpg])]  
  #         }
	# 		}, headers: {
	# 			Authorization: response.headers['Authorization']
	# 		  }
	# 	end

	# 	it 'should save the all attachaments' do
	# 		expect(response_json['flag']).to  eq(Flag::SUCCESS)
	#   end
	# 	it 'should return a created status' do
	# 		expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:created])
	#   end

  #   it 'should save the attachments in the attachments table' do
  #     expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:created])
  #   end
  # end
end