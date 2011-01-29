require 'spec_helper'

describe Repository do
  it "should not allow duplicate repo names within the scope of one user" do
    @repo1 = Factory.create :repository, name: 'Repo', user: 'user'
    @repo2 = Factory.build :repository, name: 'Repo', user: 'user'
    @repo2.save.should be_false
  end
  it "should allow duplicate repo names outside the scope of one user" do
    @repo1 = Factory.create :repository, name: 'Repo', user: 'user1'
    @repo2 = Factory.build :repository, name: 'Repo', user: 'user2'
    @repo2.save.should be_true
  end
end
