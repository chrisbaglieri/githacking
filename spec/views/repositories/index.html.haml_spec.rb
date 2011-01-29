require 'spec_helper'

describe "repositories/index.html.haml" do
  before(:each) do
    assign(:repositories, [
      stub_model(Repository,
        :name => "Name",
        :user => "User"
      ),
      stub_model(Repository,
        :name => "Name",
        :user => "User"
      )
    ])
  end

  it "renders a list of repositories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "User".to_s, :count => 2
  end
end
