require 'rails_helper'

describe Api::V1::ReportsController, type: :request do
  
    let!(:admin_user) { create_admin_user }
  
    context 'When getting all reports' do
      before do
        perform_request(user=admin_user, end_point="/api/v1/reports", payload=nil, school=nil, method="get")
      end
  
      it_behaves_like 'Shareable', { context: 'show_successful', model_name: 'report', execute_query: false }
    end
end