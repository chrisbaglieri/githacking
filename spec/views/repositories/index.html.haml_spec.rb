require 'spec_helper'

describe "repositories/index.html.haml" do
  before(:each) do
    assign(:repositories, [
      stub_model(Repository,
        :project_name => "Project name",
        :user => "User"
      ),
      stub_model(Repository,
        :project_name => "Project name",
        :user => "User"
      )
    ])
  end

  it "renders a list of repositories" do
    render
    assert_select "tr>td", :text => "Project name".to_s, :count => 2
  end
end
