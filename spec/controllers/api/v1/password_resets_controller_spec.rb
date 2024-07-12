require 'rails_helper'

describe PasswordResetsController, type: :request do
  let (:existing_user) { create_user }
  let (:password_request_url) { '/api/v1/password_reset' }
  let (:password_reset_url) { '/api/v1/password_reset' }

  context 'Requesting password reset with a non existing user email' do
    before do
      post password_request_url, params: {email: Faker::Internet.email}
    end
   
    it 'should return :ok' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
    end

    it 'Should return a warming flag' do
      expect(response_json['flag']).to  eq(Flag::WARMING)
    end
  end

  context 'Requesting password reset with an user email' do
    before do
      post password_request_url, params: {email: existing_user.email}
    end
    
    it 'should return :ok' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
    end

    it 'Should return a successful flag' do
      expect(response_json['flag']).to  eq(Flag::SUCCESS)
    end
  end

  context 'Updating password with a non existing token' do
    before do
      patch password_reset_url, params: {token: Faker::Alphanumeric.alpha(number: 20), password: Faker::Internet.password}
    end
    
    it 'should return :ok' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
    end

    it 'Should return a successful flag' do
      expect(response_json['flag']).to  eq(Flag::WARMING)
    end
  end

  context 'Updating password with an expired token' do
    before do
      post password_request_url, params: {email: existing_user.email} # request link for password update (this line save a token in existing_user )
      #existing_user.reload
      existing_user.update(password_reset_expiry_date: DateTime.now - 25.hours) # make the link expired
      existing_user.reload # reload the new update 
      patch password_reset_url, params: {token: existing_user.reset_password_token, password: Faker::Internet.password} # Reset the password of an expired token
    end
    
    it 'should return :gone' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:gone])
    end

    it 'Should return a warming flag' do
      expect(response_json['flag']).to  eq(Flag::WARMING)
    end
  end

  context 'Updating password with an unexpired token' do
    before do
      post password_request_url, params: {email: existing_user.email} # request link for password update (this line save a token in existing_user )
      existing_user.reload # reload the new update 
      patch password_reset_url, params: {token: existing_user.reset_password_token, password: Faker::Internet.password} # Reset the password of an unexpired token
    end
    
    it 'should return :ok' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
    end

    it 'Should return a successful flag' do
      expect(response_json['flag']).to  eq(Flag::SUCCESS)
    end
  end

  context 'Updating password with unvalid password' do
    before do
      post password_request_url, params: {email: existing_user.email} # request link for password update (this line save a token in existing_user )
      existing_user.reload # reload the new update 
      patch password_reset_url, params: {token: existing_user.reset_password_token, password: Faker::Internet.password(min_length: 1, max_length: 5)} # Reset the password of an unexpired token
    end
    
    it 'should return :ok' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
    end

    it 'Should return an error flag' do
      expect(response_json['flag']).to  eq(Flag::ERROR)
    end
  end


end