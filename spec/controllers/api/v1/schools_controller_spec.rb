require 'rails_helper'

describe Api::V1::SchoolsController, type: :request do
  #let! (:theme) { create_theme }
  #let declarations are only intended to be accessible from within individually examples, 
  #not from within describe or context blocks (which are eagerly evaluated, and are the context in which to define
  #let declarations, hooks, examples, etc). If we allowed let declarations to be accessed outside examples 
  # it would have unfortunate consequences such as DB records being created outside of the per-example transactions,
  #leading to inconsistent spec
	let! (:user) { create_user }
	let! (:admin_user) { create_admin_user } # always create an admin user before creating a saved school. This is used for monitoring created schools 

  let! (:school) { build_school }
	let! (:school_saved) { create_school(admin_user)}

  
  context 'When creating a school sussessfullly' do
     before do
      #Constant.set_payload(school_payload(school))
      perform_request(user=admin_user,end_point="/api/v1/schools/", payload=school_payload(school), school=nil, method="post", institutionalisable=false)
     end
     it_behaves_like 'Shareable', {context:"creation_successful", model_name:"school",execute_query: false}
    #  it "should add the attachments" do
    #   verify_school_attachment(response_json)
    # end
  end
  

	# context 'When the creation of a school fails' do
	# 	before do
  #     perform_request(user=admin_user,end_point="/api/v1/schools/", payload=school_payload(school, success=false), method="post", institutionalisable=false)
	# 	end
  #   it_behaves_like 'Shareable', {context:"failure", model_name:"school",execute_query: false}
	# 	it 'should not save the school' do
	# 		expect(School.find_by(sub_denomination: school.sub_denomination)).to be_nil   
	#   end
  # end 
	
  context 'When updating an inexisting school' do
    before do
      perform_request(user=admin_user,end_point="/api/v1/schools/#{-1}", payload=Constant.set_payload({denomination: school.denomination}), school=nil, method="put")
      #Constant.set_payload({denomination: school.denomination})
    end
    it_behaves_like 'Shareable', {context:"failure", model_name:"school",execute_query: false}
    #it_behaves_like 'Shareable', {endpoint:"/api/v1/schools/#{-1}", school:nil, method:"put", context:"failure",model_name:"school"}
  end
  
  
	context 'When updating an existing school' do
		school_attributes ={denomination: Faker::University.name}
		before do
      perform_request(user=admin_user,end_point="/api/v1/schools/#{school_saved.id}", payload=school_attributes, school=nil, method="put")
      school_saved.reload
		end
    it_behaves_like 'Shareable', {context:"update_successful", model_name:"school",execute_query: false}
		# it 'should update the denomination' do 
		# 	expect(school_saved.denomination).to  eq school_attributes[:denomination]
		# end
	end
	
	context 'when an ordinary user wants to delete a school' do
		before do
      perform_request(user,end_point="/api/v1/schools/#{school_saved.id}",payload=nil, school=nil, method="delete")
		end
    it_behaves_like 'Shareable', {context:"unauthorized", model_name:"school",execute_query: false}
	end

	context 'when an admin_user deletes a school' do
		before do
      Constant.set_resource(school_saved)
      perform_request(user=admin_user,end_point="/api/v1/schools/#{school_saved.id}",payload=nil, school=nil, method="delete")
	   end
     it_behaves_like 'Shareable', {context:"delete_successful", model_name:"school",execute_query: false}
	end
end