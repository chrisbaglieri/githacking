require 'spec_helper'

describe "repositories/show.html.haml" do
  before(:each) do
    @repository = assign(:repository, stub_model(Repository,
      :name => "Name",
      :user => "User"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/User/)
  end
end
