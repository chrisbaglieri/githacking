require 'spec_helper'

describe Issue do
  before do
    @issue = Factory.build :issue
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

  describe "build" do
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
      pending 'not sure what to do here...'
    end
  end
end
