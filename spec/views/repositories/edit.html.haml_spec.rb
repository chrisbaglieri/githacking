require 'spec_helper'

describe "repositories/edit.html.haml" do
  before(:each) do
    @repository = assign(:repository, stub_model(Repository,
      :name => "MyString",
      :user => "MyString"
    ))
  end

  it "renders the edit repository form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => repository_path(@repository), :method => "post" do
      assert_select "input#repository_project_name", :project_name => "repository[project_name]"
      assert_select "input#repository_user", :project_name => "repository[user]"
    end
  end
end
