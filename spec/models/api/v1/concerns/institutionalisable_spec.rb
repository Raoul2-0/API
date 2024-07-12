shared_examples "institutionalisable" do
  it { should have_many(:institutions) } 
  it { should have_many(:news, through: :institutions, source: :institutionalisable, source_type: 'News') } 
  it { should have_many(:extra_activities, through: :institutions, source: :institutionalisable, source_type: 'ExtraActivity') }
end 