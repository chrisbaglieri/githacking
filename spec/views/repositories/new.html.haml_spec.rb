require 'spec_helper'

describe "repositories/new.html.haml" do
  before(:each) do
    assign(:repository, stub_model(Repository,
      :name => "MyString",
      :user => "MyString"
    ).as_new_record)
  end

  it "renders new repository form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => repositories_path, :method => "post" do
      assert_select "input#repository_name", :name => "repository[name]"
      assert_select "input#repository_user", :name => "repository[user]"
    end
  end
end
