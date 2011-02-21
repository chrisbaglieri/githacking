require 'spec_helper'

describe "repositories/issues.html.haml" do
  before(:each) do
    @repository = Factory.build(:repository, id: 12345, name: 'Theprojectname', owner: 'theuser')
    assign(:repository, @repository)
    assign(:tag, 'bytesize')
  end

  it "displays an empty message if there are no issues for the given tag" do
    assign(:issues, [])
    
    render

    rendered.should match(/Sorry, can't find any bytesize issues to work on./)
  end

  it 'lists issues if they are displayed' do
    issues = (0..2).to_a.collect { |x| Factory.create :open_issue, title: "The #{x} title", body: "The #{x} body", repository: @repository }
    assign(:issues, issues)

    render

    3.times do |x|
      rendered.should match(/The #{x} title/)
      rendered.should match(/The #{x} body/)
    end
  end
end
