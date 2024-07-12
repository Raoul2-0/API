shared_examples "monitorable" do
  it { should have_one(:monitoring) }
end