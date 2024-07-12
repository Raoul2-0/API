require 'faker'
require 'factory_bot_rails'

module TimingHelpers
  def timing_parameters(resource)
    {
      start_time: Faker::Time.forward(days: 1),
      end_time: Faker::Time.forward(days: 1, period: :evening),
      timeable: resource
    }
  end

  def create_timing(resource)
    handle_monitoring(FactoryBot.create(:timing, timing_parameters(resource)))
  end

  def build_timing(resource)
    FactoryBot.build(:timing, timing_parameters(resource))
  end

  def timing_payload(timing, success=true)
    if success
      {
        start_time: timing.start_time,
        end_time: timing.end_time
      }
    end
  end
end
