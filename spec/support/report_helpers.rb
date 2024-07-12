require 'faker'
require 'factory_bot_rails'

module ReportHelpers
  def report_parameters(reportable_id=0, reportable_type=nil)
    {
      denomination: Faker::Lorem.word,
      description: Faker::Lorem.paragraph,
      reportable_id: reportable_id,
      reportable_type: reportable_type
    }
  end

  def create_report(reportable_id=0, reportable_type=nil)
    handle_monitoring(FactoryBot.create(:report, report_parameters(reportable_id, reportable_type)))
  end

  def build_report(reportable_id=0, reportable_type=nil)
    FactoryBot.build(:report, report_parameters(reportable_id, reportable_type))
  end

  def report_payload(report, success=true)
    if success
      {
        denomination: report.denomination,
        description: report.description,
        reportable_id: report.reportable_id,
        reportable_type: report.reportable_type
      }
    end
  end
end
