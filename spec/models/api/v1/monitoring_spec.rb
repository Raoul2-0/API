require 'rails_helper'

RSpec.describe Monitoring, type: :model do
  # columns added by the polimorphic association
  it { is_expected.to have_db_column(:monitorable_id).of_type(:integer) }
  it { is_expected.to have_db_column(:monitorable_type).of_type(:string) }
  
  # specific columns 
  it { is_expected.to have_db_column(:status).of_type(:integer) }
  it { is_expected.to have_db_column(:start_date).of_type(:datetime) }
  it { is_expected.to have_db_column(:end_date).of_type(:datetime) }
  
  # Columns added by the association with user
  it { is_expected.to have_db_column(:create_who_id).of_type(:integer) }
  it { is_expected.to have_db_column(:update_who_id).of_type(:integer) }
  #it { is_expected.to have_db_column(:delete_who_id).of_type(:integer) }
  

  it { should belong_to(:monitorable) }
  it { should belong_to(:create_who) }
  it { should belong_to(:update_who).optional }
  #it { should belong_to(:delete_who).optional }
end
