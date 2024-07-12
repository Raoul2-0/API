require 'rails_helper'

describe Api::V1::EvaluationsController, type: :request do
  
  let!(:admin_user) { create_admin_user }
  
  let!(:evaluation) { build_evaluation_with_timing }

  let! (:evaluation_saved) { create_evaluation_with_timing }

  let! (:report_saved) { create_report(evaluation_saved.id, "Evaluation") }
    
  context 'When creating an evaluation successfully' do
    before do
      perform_request(user=admin_user,end_point="/api/v1/evaluations/", payload=evaluation_payload_with_timing(evaluation), school=nil, method="post", institutionalisable=true)
    end

    it_behaves_like 'Shareable', { context: 'creation_successful', model_name: 'evaluation', execute_query: false }
  end

  context 'When showing an evaluation' do
    before do
      perform_request(user=admin_user, end_point="/api/v1/evaluations/#{evaluation_saved.id}", payload=nil, school=nil, method="get")
    end

    it_behaves_like 'Shareable', { context: 'show_successful', model_name: 'evaluation', execute_query: false }
  end
  
  context 'When destroying an evaluation' do 
    before do
      perform_request(user=admin_user, end_point="/api/v1/evaluations/#{evaluation_saved.id}", payload=nil, school=nil, method="delete")
    end
  
    it_behaves_like 'Shareable', { context: 'delete_successful', model_name: 'evaluation', execute_query: false }
  end  
  
  context 'When updating an existing evaluation' do
    let!(:new_evaluation) { build_evaluation_with_timing }
    before do
      perform_request(user=admin_user, end_point="/api/v1/evaluations/#{evaluation_saved.id}", payload=evaluation_payload_without_timing(new_evaluation), school=nil, method="patch")
      evaluation_saved.reload
		end
    it_behaves_like 'Shareable', {context:"update_successful", model_name:"evaluation",execute_query: false}
    it 'should verify if all the attributes are updated' do
			verify_all_evaluation_attributes_updated(new_evaluation, evaluation_saved)
		end
	end

  context 'When creating a report for an evaluation successfully' do
    let!(:report) { build_report(evaluation_saved.id, "Evaluation") }
    before do
      perform_request(user=admin_user, end_point="/api/v1/reports", payload=report_payload(report), school=nil, method="post")
    end

    it_behaves_like 'Shareable', { context: 'creation_successful', model_name: 'evaluation', execute_query: false }
  end

  context 'When showing the reports for an evaluation' do
    let!(:report) { create_report(evaluation_saved.id, "Evaluation") }
    before do
      perform_request(user=admin_user, end_point="/api/v1/reports?reportable_type=Evaluation", payload=nil, school=nil, method="get")
    end

    it_behaves_like 'Shareable', { context: 'show_successful', model_name: 'evaluation', execute_query: false }
  end

  context 'When updating a report for an evaluation' do
    let!(:new_report) { build_report(evaluation_saved.id, "Evaluation") }
    before do
      perform_request(user=admin_user, end_point="/api/v1/reports/#{report_saved.id}", payload=report_payload(new_report), school=nil, method="patch")
    end

    it_behaves_like 'Shareable', { context: 'update_successful', model_name: 'evaluation', execute_query: false }
  end

  context 'When destroying a report for an evaluation' do
    before do
      perform_request(user=admin_user, end_point="/api/v1/reports/#{report_saved.id}", payload=nil, school=nil, method="delete")
    end

    it_behaves_like 'Shareable', { context: 'delete_successful', model_name: 'evaluation', execute_query: false }
  end

end