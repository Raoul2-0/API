require 'rails_helper'

describe Api::V1::CourseGeneralitiesController, type: :request do

  
    let!(:admin_user) { create_admin_user }
    let!(:course_generality) { build_course_generality }
    let!(:course_generality_saved) { create_course_generality }
    

    context 'When creating a course_generality successfully' do
        before do
          perform_request(user=admin_user,end_point="/api/v1/course_generalities", payload=course_generality_payload(course_generality), school=nil, method="post", institutionalisable=true)
        end
    
        it_behaves_like 'Shareable', { context: 'creation_successful', model_name: 'course_generality', execute_query: false }
    end

    context 'When showing a course_generality' do
        before do
          perform_request(user=admin_user, end_point="/api/v1/course_generalities/#{course_generality_saved.id}", payload=nil, school=nil, method="get")
        end
    
        it_behaves_like 'Shareable', { context: 'show_successful', model_name: 'course_generality', execute_query: false }
    end

    context 'When destroying a course_generality ' do 
        before do
          perform_request(user=admin_user, end_point="/api/v1/course_generalities/#{course_generality_saved.id}", payload=nil, school=nil, method="delete")
        end
      
        it_behaves_like 'Shareable', { context: 'delete_successful', model_name: 'course_generality', execute_query: false }
    end  

    context 'When updating an existing course_generality' do
      let!(:new_course_generality) { build_course_generality}
        before do
        
          perform_request(user=admin_user,end_point="/api/v1/course_generalities/#{course_generality_saved.id}", payload=course_generality_payload(new_course_generality), school=nil, method="patch")
          course_generality_saved.reload
        end
        
        it_behaves_like 'Shareable', {context:"update_successful", model_name:"course_generality",execute_query: false}
        it 'should verify if all the attributes are updated' do
                verify_all_course_attributes_updated(new_course_generality, course_generality_saved)
        end
    end
end