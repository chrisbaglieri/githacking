require 'spec_helper'

describe "repositories/show.html.haml" do
  before(:each) do
    @repository = Factory.build(:repository, id: 12345, name: 'Theprojectname', owner: 'theuser')
    stub_metadata_request @repository.owner, @repository.name
    assign(:repository, @repository)
  end

  it "renders attributes in <p>" do
    render

    rendered.should match(/Theprojectname/)
    rendered.should match(/theuser/)
  end
end
