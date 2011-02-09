require 'spec_helper'

describe "repositories/issues.html.haml" do
  before(:each) do
    stub_github_requests_for(@repository = Factory.build(:repository, name: 'Theprojectname', owner: 'theuser'))

    @repository.save!
    assign(:repository, @repository)
    assign(:tag, 'bytesize')
  end

  it "displays an empty message if there are no issues for the given tag" do
    assign(:issues, [])
    
    render

    rendered.should match(/Sorry, can't find any bytesize issues to work on./)
  end

  # TODO: update with factory issues when Aaron gets them in.
  it 'lists issues if they are displayed' do
    assign(:issues, (0..2).to_a.collect do |x|
             a = double Object
             a.should_receive(:number).and_return x
             a.should_receive(:title).and_return "The #{x} title"
             a.should_receive(:updated_at).and_return Time.now
             a.should_receive(:body).and_return "The #{x} body"
             a
           end)

    render

    3.times do |x|
      rendered.should match(/The #{x} title/)
      rendered.should match(/The #{x} body/)
    end
  end
end
