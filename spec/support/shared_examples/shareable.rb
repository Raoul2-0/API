RSpec.shared_examples 'Shareable' do |parameters|
  context "When #{parameters[:action]} a #{parameters[:model_name]}" do
		before do
      if !parameters.has_key?(:execute_query)
        perform_request(admin_user,endpoint=parameters[:endpoint], payload=Constant.payload, method=parameters[:method])
      end
		end

    case parameters[:context]
      when "creation_successful"
        it "should save the #{parameters[:model_name]}: returns created state" do
          expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:created])
        end
        it "should add the monitor with status ACTIVATED" do
          verify_monitor(action=Constant::RESOURCE_METHODS[:create], user=admin_user)
        end

      when "update_successful"
        it 'should return :ok status' do
          expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
        end

        it "should update user who updated the resource" do
          verify_monitor(action=Constant::RESOURCE_METHODS[:update], user=admin_user)
        end

      when "failure"
          it "returns not found" do
            expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found]) if response_json["status"]
          end

          it "should not recognize the #{parameters[:model_name]}" do
            expect(response_json["flag"]).to  eq(Flag::WARMING) if response_json["flag"]
          end

      when "unauthorized"
        it 'should return unauthorized: 401' do
          expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:unauthorized])
        end
         it 'should return an error flag' do 
          expect(response_json["flag"]).to eq(Flag::ERROR)
        end

      when "delete_successful"
        it 'returns 200' do
          expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
        end 
        it 'should return a successful flag' do 
            expect(response_json["flag"]).to eq(Flag::SUCCESS)
        end
    
        it "should update the monitor of the user who deleted the school" do
          verify_monitor(action=Constant::RESOURCE_METHODS[:delete], user=admin_user,resource=Constant.resource_saved)
        end

      when "show_successful"
        it 'returns 200' do
          expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok])
        end 
    end
  end
end