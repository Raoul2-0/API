require 'rails_helper'

describe Api::V1::HomeworksController, type: :request do

  
    let!(:admin_user) { create_admin_user }
    let!(:school) { create_school(admin_user) }
    let!(:serve) { create_serve(school) }
    let!(:course) { create_course(school, admin_user) }
    let!(:homework) { build_homework(serve,course) }
    let!(:homework_saved) { create_homework(serve,course) }
    

    context 'When creating a homework successfully' do
        before do
          
          perform_request(user=admin_user,end_point="/api/v1/homeworks?record_type=Course&record_id=#{course.id}", payload=homework_payload(homework), school=school, method="post", institutionalisable=false)
        #binding.pry
        end
    
        it_behaves_like 'Shareable', { context: 'creation_successful', model_name: 'homework', execute_query: false }
    end

    context 'When showing a homework' do
        before do
          perform_request(user=admin_user, end_point="/api/v1/homeworks/#{homework_saved.id}", payload=nil, school=@school, method="get")
        end
    
        it_behaves_like 'Shareable', { context: 'show_successful', model_name: 'homework', execute_query: false }
    end

    context 'When destroying a homework ' do 
        before do
          perform_request(user=admin_user, end_point="/api/v1/homeworks/#{homework_saved.id}", payload=nil, school=@school, method="delete")
        end
      
        it_behaves_like 'Shareable', { context: 'delete_successful', model_name: 'homework', execute_query: false }
    end  

    context 'When updating an existing homework' do
      let!(:new_homework) { build_homework(serve,course)}
        before do
        
          perform_request(user=admin_user,end_point="/api/v1/homeworks/#{homework_saved.id}", payload=homework_payload(new_homework), school=@school, method="patch")
          homework_saved.reload
        end
        
        it_behaves_like 'Shareable', {context:"update_successful", model_name:"homework",execute_query: false}
        it 'should verify if all the attributes are updated' do
                verify_all_homework_attributes_updated(new_homework, homework_saved)
        end
    end
end