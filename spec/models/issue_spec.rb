require 'spec_helper'

describe Issue do
  before do
    @issue = Issue.new
  end

  describe "timestamps" do
    before do
      @now = Time.now
    end

    describe "when setting created_at" do
      it "should set created_at_github" do
        @issue.created_at = @now
        @issue.created_at_github.should == @now
      end

      it "should set created_at_github" do
        @issue.updated_at = @now
        @issue.updated_at_github.should == @now
      end
    end
  end
end
