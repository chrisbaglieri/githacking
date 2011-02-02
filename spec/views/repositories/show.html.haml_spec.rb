require 'spec_helper'

describe "repositories/show.html.haml" do
  before(:each) do
    stub_all_github_requests_for(@repository = Factory.build(:repository, project_name: 'Theprojectname', user: 'theuser'))

    @repository.save!
    assign(:repository, @repository)
  end

  it "renders attributes in <p>" do
    render

    rendered.should match(/Theprojectname/)
    rendered.should match(/theuser/)
  end
end
