require 'rails_helper'

describe Api::V1::CoursesController, type: :request do
  
  let!(:admin_user) { create_admin_user }

  let! (:school) { create_school(admin_user) }
  
  let!(:course) { build_course(school, admin_user) }

  let! (:course_saved) { create_course(school, admin_user) }

  let! (:report_saved) { create_report(course_saved.id, "Course") }
    
  context 'When creating a course successfully' do
    before do
      @school=create_school(admin_user)
      perform_request(user=admin_user,end_point="/api/v1/scholastic_periods/", payload=scholastic_period_payload(build_scholastic_period), school=@school, method="post", institutionalisable=false)

      @scholastic_period_id = response_json["id"]

      perform_request(user=admin_user,end_point="/api/v1/courses/", payload=course_payload(course, school, @scholastic_period_id), school=@school, method="post", institutionalisable=false)
    end

    it_behaves_like 'Shareable', { context: 'creation_successful', model_name: 'course', execute_query: false }
  end

  context 'When showing a course' do
    before do
      perform_request(user=admin_user, end_point="/api/v1/courses/#{course_saved.id}", payload=nil, school=create_school(admin_user), method="get", institutionalisable=false)
    end

    it_behaves_like 'Shareable', { context: 'show_successful', model_name: 'course', execute_query: false }
  end
  
  context 'When updating an existing course' do
    #@scholastic_period_id = response_json["id"]
    before do
      @school=create_school(admin_user)
      @new_course = build_course(@school, admin_user)
      perform_request(user=admin_user,end_point="/api/v1/scholastic_periods/", payload=scholastic_period_payload(build_scholastic_period), school=@school, method="post", institutionalisable=false)

      @scholastic_period_id = response_json["id"]

      perform_request(user=admin_user, end_point="/api/v1/courses/#{course_saved.id}", payload=course_payload(@new_course, school, @scholastic_period_id), school=create_school(admin_user), method="patch", institutionalisable=false)
      course_saved.reload
		end
    it_behaves_like 'Shareable', {context:"update_successful", model_name:"course",execute_query: false}
	end
  
  context 'When destroying a course' do 
    before do
      perform_request(user=admin_user, end_point="/api/v1/courses/#{course_saved.id}", payload=nil, school=create_school(admin_user), method="delete", institutionalisable=false)
    end
  
    it_behaves_like 'Shareable', { context: 'delete_successful', model_name: 'course', execute_query: false }
  end  

  context 'When creating a report for a course successfully' do
    let!(:report) { build_report(course_saved.id, "Course") }
    before do
      perform_request(user=admin_user, end_point="/api/v1/reports", payload=report_payload(report), school=create_school(admin_user), method="post", institutionalisable=false)
    end

    it_behaves_like 'Shareable', { context: 'creation_successful', model_name: 'course', execute_query: false }
  end

  context 'When showing the reports for a course' do
    let!(:report) { create_report(course_saved.id, "Course") }
    before do
      perform_request(user=admin_user, end_point="/api/v1/reports?reportable_type=Course", payload=nil, school=create_school(admin_user), method="get", institutionalisable=false)
    end

    it_behaves_like 'Shareable', { context: 'show_successful', model_name: 'course', execute_query: false }
  end

  context 'When updating a report for a course' do
    let!(:new_report) { build_report(course_saved.id, "Course") }
    before do
      perform_request(user=admin_user, end_point="/api/v1/reports/#{report_saved.id}", payload=report_payload(new_report), school=create_school(admin_user), method="patch", institutionalisable=false)
    end

    it_behaves_like 'Shareable', { context: 'update_successful', model_name: 'course', execute_query: false }
  end

  context 'When destroying a report for a course' do
    before do
      perform_request(user=admin_user, end_point="/api/v1/reports/#{report_saved.id}", payload=nil, school=create_school(admin_user), method="delete", institutionalisable=false)
    end

    it_behaves_like 'Shareable', { context: 'delete_successful', model_name: 'course', execute_query: false }
  end

  context 'When showing the teachers for a course' do
    before do
      perform_request(user=admin_user, end_point="/api/v1/courses/#{course_saved.id}/teachers", payload=nil, school=nil, method="get")
    end

    it_behaves_like 'Shareable', { context: 'show_successful', model_name: 'course', execute_query: false }
  end

end