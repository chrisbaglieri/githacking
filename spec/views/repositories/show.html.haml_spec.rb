require 'spec_helper'

describe "repositories/show.html.haml" do
  before(:each) do
    @repository = assign(:repository, stub_model(Repository,
                                                 :name => "Name",
                                                 :user => "User"
                                                 ))
    @github = double Object
    @repository.stub!(:github).and_return(@github)
    @github.stub!(:issues).and_return({})
    @github.stub!(:url).and_return('http://theurl.com')
    @github.stub!(:description).and_return('The description of the project')
    @github.stub!(:languages).and_return({'languageA' => 12345, 'languageB' => 43111, 'languageC' => 14141})
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/User/)
  end
end
