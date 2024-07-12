require 'rails_helper'

describe RegistrationsController, type: :request do

  let (:user) { build_user }
  let (:existing_user) { create_user }
  let (:admin_user) {create_admin_user}
  let (:school) {create_school(create_admin_user)}
  let (:signup_url) { '/api/v1/signup' }

  context 'When creating a new user' do
    before do
      registration_with_api(user, school.id) # 1 refers to a school id e.g School.first[:id]. This line should be replaced with a line save in the School table
    end

    it 'returns :ok' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
    end

    it 'returns a token' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns a success flag' do
      expect(response_json['flag']).to  eq(Flag::SUCCESS)
    end

    it 'should create the associated monitoring' do
      #user_monitor = Theme.find_by_id(theme_save.id).monitoring
      saved_user = User.find_by_email(user.email)
      user_monitor = saved_user.monitoring
      #if user_monitor 
      expect(user_monitor[:status]).to eq(Status::PUBLISHED)
      expect(user_monitor[:create_who_id]).to eq(saved_user.id)
      #end
      
    end
  end

  # context 'When an email already exists' do
  #   before do
  #     post signup_url, params: {
  #       user: {
  #         email: existing_user.email,
  #         password: existing_user.password
  #       }
  #     }
  #   end

  #   it 'returns 400' do
  #     expect(response.status).to eq(400)
  #   end
  # end

end