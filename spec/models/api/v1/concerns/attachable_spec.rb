shared_examples "attachable" do
  it { should have_many(:attachments) }
end