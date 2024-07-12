require 'rails_helper'

describe ConfirmationsController, type: :request do
  let (:user) { build_user }
  let (:existing_user) { create_user }

  let (:confirmation_url) { '/api/v1/confirmation' }

  #school = create_school(create_admin_user)
  #headers.merge!(X-school-id: school.id)
  context 'When confirming a not already confirmed email address with a valid token' do
    before do
      registration_with_api(user, nil) # simulate a registration without a school
      
      token = User.find_by_email(user.email).confirmation_token   # get the saved token
      post confirmation_url, params: {confirmation_token: token}
    end

    it 'should return :ok' do
      
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
    end

    it 'should return a successful flag' do
      expect(response_json['flag']).to  eq(Flag::SUCCESS)
    end
  end

  context 'When confirming an already confirmed email address with a valid token' do
    before do
      registration_with_api(user, nil) # simulate a registration
      newUser = User.find_by_email(user.email)
      token = newUser.confirmation_token   # get the saved token
      newUser.validate_email
      newUser.save(validate: false)
      post confirmation_url, params: {confirmation_token: token}
    end

    it 'should return :ok' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found])
    end

    it 'should return a successful flag' do
      expect(response_json['flag']).to  eq(Flag::WARMING)
    end
  end
end
