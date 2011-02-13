require 'spec_helper'

describe Issue do
  before do
    @issue = Factory.build :open_issue
  end

  describe "timestamps" do
    before do
      @now = Time.now
    end

    describe "when setting created_at" do
      it "should set created_at_github" do
        @issue.created_at_github = nil
        @issue.created_at = @now
        @issue.created_at_github.should == @now
      end

      it "should set created_at_github" do
        @issue.updated_at_github = nil
        @issue.updated_at = @now
        @issue.updated_at_github.should == @now
      end
    end
  end

  describe "#build" do
    it "should build OpenIssue" do
      issue_hash = {'state' => 'open'}
      open_issue = Issue.build(issue_hash)

      open_issue.class.should == OpenIssue
    end

    it "should build ClosedIssue" do
      issue_hash = {'state' => 'closed'}
      open_issue = Issue.build(issue_hash)

      open_issue.class.should == ClosedIssue
    end

    it "should remove 'state' from input hash b/c state column is STI type" do
      issue_hash = {'state' => 'closed'}
      Issue.build(issue_hash)

      assert_equal  false, issue_hash.has_key?('state')
    end

    it "should handle when issue state is not open or closed" do
      -> { Issue.build(state: 'somethingelse') }.should raise_error
    end
  end

  describe "#distance_in_the_past" do
    describe 'should calculate how long in the past an issue was created' do
      it 'when greater than 1 day' do
        issue = Factory.create :open_issue
        issue.should_receive(:created_at).and_return Time.now - 1.day - 1.hour
        issue.distance_in_the_past.should == "1 day ago"
      end
      it 'when greater than 2 day' do
        issue = Factory.create :open_issue
        issue.should_receive(:created_at).and_return Time.now - 2.day - 1.hour
        issue.distance_in_the_past.should == "2 days ago"
      end
      it 'when greater than 1 hour' do
        issue = Factory.create :open_issue
        issue.should_receive(:created_at).and_return Time.now - 1.hour - 1.minute
        issue.distance_in_the_past.should == "1 hour ago"
      end
      it 'when greater than 1 minute' do
        issue = Factory.create :open_issue
        issue.should_receive(:created_at).and_return Time.now - 1.minute - 10.seconds
        issue.distance_in_the_past.should == "1 minute ago"
      end
      it 'when less than one 1 minute' do
        issue = Factory.create :open_issue
        issue.should_receive(:created_at).and_return Time.now - 10.seconds
        issue.distance_in_the_past.should == '10 seconds ago'
      end
      it 'when less than one 1 second' do
        issue = Factory.create :open_issue
        issue.should_receive(:created_at).and_return Time.now
        issue.distance_in_the_past.should match(/milisecond/)
      end
    end
    
  end
end
