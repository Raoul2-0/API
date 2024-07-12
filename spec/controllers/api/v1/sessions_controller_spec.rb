require 'rails_helper'

describe SessionsController, type: :request do

  let (:user) { create_user }
  let (:login_url) { '/api/v1/login' }
  let (:logout_url) { '/api/v1/logout' }

  context 'When logging in' do
    before do
      login_with_api(user)
    end

    it 'returns a token' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns 200' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
    end
  end

  context 'When password is missing' do
    before do
      post login_url, params: {
        user: {
          email: user.email,
          password: nil
        }
      }
    end

    it 'returns 422' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:unprocessable_entity])
    end

  end

  context 'When login with a disabled account' do
    before do
      user.disabled = true
      user.save!
      login_with_api(user)
    end

    it 'returns :ok' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
    end

    it 'should return a warming flag' do
      expect(response_json['flag']).to  eq(Flag::WARMING)
    end

    it 'should return a warming flag' do
      expect(response_json['message']).to  eq(I18n.t 'sessions.inactive')
    end
  end

  context 'When logging out' do
    it 'returns 204' do
      delete logout_url

      expect(response).to have_http_status(204)
    end
  end

end