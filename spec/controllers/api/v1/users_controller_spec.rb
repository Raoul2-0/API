require 'rails_helper'

describe Api::V1::UsersController, type: :request do

  let! (:user) { create_user }
  let! (:user2) { create_user }
  let! (:admin_user) { create_admin_user }
  context 'When fetching a user' do
    before do
      #login_with_api(user)
      get "/api/v1/users/#{user.id}"
      # , headers: {
      #   Authorization: response.headers['Authorization']
      # }
    end

    it 'returns :ok' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
    end

    it 'returns the user' do
      expect(response_json["id"]).to eq(user.id)
    end
  end

  context 'When fetching a missing a user' do
    before do
      #login_with_api(user)
      get "/api/v1/users/blank"
      # , headers: {
      #   Authorization: response.headers['Authorization']
      # }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end

  # This is not longer needed because get on resource does not need authorization
  # context 'When the Authorization header is missing' do
  #   before do
  #     get "/api/v1/users/#{user.id}"
  #   end

  #   it 'returns 401' do
  #     expect(response.status).to eq(401)
  #   end
  # end

  
  context 'When getting a user' do
    before do
      login_with_api(user)
      get "/api/v1/users/#{user.id}", headers: {
        Authorization: response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    # it 'removes user from table users' do
    #   @user_to_delete = create_user
    #   expect{ delete :destroy, id: @user_to_delete }.to change(User, :count).by(-1)
    # end
  end

  context 'When updating an inexisting user' do
    before do
      login_with_api(user)
      patch "/api/v1/users/#{-1}", params: {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
     }, headers: {
      Authorization: response.headers['Authorization']
    }
    end

    it 'returns :ok' do
      expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
    end

    it 'returns "Not Found" if user does not exist' do
      expect(response_json["flag"]).to eq(Flag::WARMING)
    end
  end

  # Testing user update 
  context 'When updating an existing  user' do
    user_attributes =
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name
    }
   
    before do
      login_with_api(user)
      patch "/api/v1/users/#{user.id}", params: {user: user_attributes}, headers: {
      Authorization: response.headers['Authorization']
    } 
    user.reload
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    # it 'should return a succes flag' do 
    #   expect(response_json["flag"]).to eq(Flag::SUCCESS)
    # end

    it 'should update the first name' do 
      expect(user.first_name).to eq user_attributes[:first_name]
    end
    it 'should update the last name' do 
      expect(user.last_name).to eq user_attributes[:last_name]
    end
  end
            # soft deletion
  # Testing destroy method for user: user performs soft deletion
  # context 'When a user performs a soft deletion of its proper account' do
  #   before do
  #     login_with_api(user)
  #     delete "/api/v1/users/#{user.id}",  headers: {
  #     Authorization: response.headers['Authorization']
  #   } 
  #   user.reload
  #   end
  #   it 'returns 200' do
  #     expect(response.status).to eq(200)
  #   end

  #   it 'should return a succes flag' do 
  #     expect(response_json["flag"]).to eq(Flag::SUCCESS)
  #   end

  #   it 'should update the deleted attribute to true' do 
  #     expect(user.deleted).to be true
  #   end
  # end

  #   # Testing destroy method for user: admin performs soft deletion
  #   context 'When an admin performs a soft deletion of a user account' do
  #     before do
  #       login_with_api(user)
  #       delete "/api/v1/users/#{admin_user.id}", params: {"id_user": user.id}, headers: {
  #       Authorization: response.headers['Authorization']
  #     } 
  #     user.reload
  #     end
  #     it 'returns 200' do
  #       expect(response.status).to eq(200)
  #     end
  
  #     it 'should return a succes flag' do 
  #       expect(response_json["flag"]).to eq(Flag::SUCCESS)
  #     end
      
  #     it 'admin user role should be :admin' do
  #       expect(admin_user.has_role? :admin).to be true
  #     end

  #     it 'should update the deleted attribute to true' do 
  #       expect(user.deleted).to be true
  #     end
  #   end

  #   # Testing destroy method for user: simple performs soft deletion of another user
  #   context 'When a simple user performs a soft deletion of another user account' do
  #     before do
  #       login_with_api(user)
  #       delete "/api/v1/users/#{user.id}", params: {"id_user": user2.id}, headers: {
  #       Authorization: response.headers['Authorization']
  #     } 
  #     user2.reload
  #     end
  #     it 'returns 200' do
  #       expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found])
  #     end
  
  #     it 'should return a succes flag' do 
  #       expect(response_json["flag"]).to eq(Flag::WARMING)
  #     end
      
  #     it 'should not be an admin user' do
  #       expect(user.has_role? :admin).to be false
  #     end

  #     it 'should update the deleted attribute to true' do 
  #       expect(user2.deleted).to be false
  #     end
  #   end


              # Permanent deletion
  # Testing destroy method for user: user performs permanent deletion of its account
  # context 'When a user performs a permanent deletion of its proper account' do
  #   let (:deleted_id) { user.id }
  #   before do
  #     login_with_api(user)
  #     delete "/api/v1/users/#{user.id}",  headers: {
  #     Authorization: response.headers['Authorization'], 
  #     destroy: "true"
  #   } 
  #   end
  #   it 'returns 200' do
  #     expect(response.status).to eq(200)
  #   end

  #   it 'should return a succes flag' do 
  #     expect(response_json["flag"]).to eq(Flag::SUCCESS)
  #   end

  #   it 'should completely delete the user from the database' do
  #     expect(User.find_by_id(deleted_id)).to be nil
  #   end
  # end

    # Testing destroy method for user: admin performs permanent deletion of another user
    # context 'When an admin performs a permanent deletion of another user account' do
    #   let (:deleted_id) { user.id }
    #   before do
    #     login_with_api(user)
    #     delete "/api/v1/users/#{admin_user.id}", params: {id_user: user.id}, headers: {
    #     Authorization: response.headers['Authorization'],
    #     destroy: "true"
    #   } 
    #   end
    #   it 'returns 200' do
    #     expect(response.status).to eq(200)
    #   end
  
    #   it 'should return a succes flag' do 
    #     expect(response_json["flag"]).to eq(Flag::SUCCESS)
    #   end
      
    #   it 'admin user role should be :admin' do
    #     expect(admin_user.admin?).to be true
    #   end

    #   it 'should completely delete the user from the database' do 
    #     expect(User.find_by_id(deleted_id)).to be nil
    #   end
    # end

    # Testing destroy method for user: simple attempt to perform permanent deletion of another user
    # context 'When a simple performs a permanent deletion of another user' do
    #   let (:deleted_id) { user2.id }
    #   before do
    #     login_with_api(user)
    #     delete "/api/v1/users/#{user.id}", params: {id_user: user2.id}, headers: {
    #     Authorization: response.headers['Authorization'], 
    #     destroy: "true"
    #   } 
      
    #   end
    #   it 'returns 200' do
    #     expect(response.status).to eq(200)
    #   end
  
    #   it 'should return a succes flag' do 
    #     expect(response_json["flag"]).to eq(Flag::WARMING)
    #   end
      
    #   it 'should not be an admin user' do
    #     expect(user.admin? :admin).to be false
    #   end

    #   it 'should not be allow to delete the user' do 
    #     expect(User.find_by_id(deleted_id)[:id]).to be user2.id
    #   end
    # end
end