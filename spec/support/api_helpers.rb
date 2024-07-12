module ApiHelpers
  include Utils
  # parse a response body of any request
  def response_json
    return JSON.parse(response.body)
  end

  # defines a function for  performing login whenever possible
  def login_with_api(user)
    post '/api/v1/login', params: {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  # defines a function for  performing registration whenever possible
  def registration_with_api(user, school_id)
    post '/api/v1/signup', params: {
      
        email: user.email,
        password: user.password,
        first_name: user.first_name,
        last_name: user.last_name,
        identification_number: user.identification_number,
        sex: user.sex,
        birthday: user.birthday,
        phones: user.phones,
        address: user.address,
      },headers: { 'X-school-id': school_id}  
  end
   

  
  # performs any kind of request given a user an endpoint the method and a possible payload
  def perform_request(user=current_user,end_point="", payload=nil, school=nil, method="post", institutionalisable=true)
    login_with_api(user)
    headers = {Authorization: response.headers['Authorization']}

    headers.merge!('X-resource-data-type': "original")
    if school.nil?
      school = create_school(create_admin_user)
      headers.merge!('X-school-id': school.id)
    else
      headers.merge!('X-school-id': school.id)
    end
    case method
      when "post"
        post end_point,params: payload, headers: headers
      when "get"
        get end_point,headers: headers
      when "put"
        put end_point,params: payload, headers: headers
      when "patch"
        patch end_point,params: payload, headers: headers 
      when "delete"
        delete end_point, headers: headers
      end	
	end
  
  # defines a function for verifying if a monitor was created/updated after creation update or deletion of a resource
  def verify_monitor(action=Constant::RESOURCE_METHODS[:create], user=current_user, resource=nil)
    case action
      when Constant::RESOURCE_METHODS[:create]
        expect(response_json["monitor"]["create_who_fullname"]).to eq(user.fullname)
        expect(response_json["monitor"]["status"]).to eq(Status::PUBLISHED)
        expect(response_json["monitor"]["start_date"]).to be_nil
        expect(response_json["monitor"]["end_date"]).to be_nil
      when Constant::RESOURCE_METHODS[:update]
        expect(response_json["monitor"]["update_who_fullname"]).to eq(user.fullname)
      when Constant::RESOURCE_METHODS[:delete]
        if resource.respond_to?(:monitoring)
          monitor = resource.monitoring #if !resource.nil?
          expect(monitor.status).to eq(Status::DELETED)
          expect(monitor.update_who_id).to eq(user.id)
        end
    end
  end

  # monitoring resource in test environment
  def handle_monitoring(resource, method=Constant::RESOURCE_METHODS[:create], user=nil)
    user = create_admin_user unless user
    update_monitor(resource, method, { user: user, monitor_attributes: {} })
    resource
  end

  # defines a function for verifying record not found of any resource
  # def verify_record_not_found(resource_name)
  #     it "returns not found" do
  #       expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found])
  #     end
        
  #     it "should not recognize the #{resource_name}" do
  #       expect(response_json['flag']).to  eq(Flag::WARMING)
  #     end
  # end
end


