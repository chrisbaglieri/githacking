require 'spec_helper'

describe Repository do
  it "should not allow users who are not on github to create project" do
    Octopi::User.stub!(:find).with("user").and_return {
        raise Octopi::NotFound.new("User")
    }
    @repo = Factory.build :repository, name: 'testing', user: 'user'
    @repo.valid?
    @repo.errors[:user].should == ["The User you were looking for could not be found, or is private."]
  end
  it "should not allow repos that don't exist on a user" do
    Octopi::Repository.stub!(:new).with(:user => "user", :name => "testing").and_return {
        raise Octopi::NotFound.new("Repository")
    }
    @repo = Factory.build :repository, name: 'testing', user: 'user'
    @repo.valid?
    @repo.errors[:name].should == ["The Repository you were looking for could not be found, or is private."]
  end
  it "should not allow duplicate repo names within the scope of one user" do
    user = double Object
    Octopi::User.stub!(:find).with("user").and_return(user)
    user.should_receive(:repository).twice
    @repo1 = Factory.create :repository, name: 'Repo', user: 'user'
    @repo2 = Factory.build :repository, name: 'Repo', user: 'user'
    @repo2.save.should be_false
  end
  it "should allow duplicate repo names outside the scope of one user" do
    user = double Object
    Octopi::User.stub!(:find).with("user1").and_return(user)
    user.should_receive(:repository)
    user2 = double Object
    Octopi::User.stub!(:find).with("user2").and_return(user2)
    user2.should_receive(:repository)
    @repo1 = Factory.create :repository, name: 'Repo', user: 'user1'
    @repo2 = Factory.build :repository, name: 'Repo', user: 'user2'
    @repo2.save.should be_true
  end
end
