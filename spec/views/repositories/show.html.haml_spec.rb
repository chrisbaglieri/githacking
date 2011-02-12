require 'spec_helper'

describe "repositories/show.html.haml" do
  before(:each) do
    stub_github_requests_for(@repository = Factory.build(:repository, name: 'Theprojectname', owner: 'theuser'))

    @repository.save!
    assign(:repository, @repository)
  end

  it "renders attributes in <p>" do
    @repository.should_receive(:labeled_issues).and_return({})
    render

    rendered.should match(/Theprojectname/)
    rendered.should match(/theuser/)
  end
end
