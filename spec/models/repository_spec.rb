require 'spec_helper'

describe Repository do
  before do
    @repo = Factory.build :repository, project_name: 'testing', user: 'user'
  end

  it "should handle when users who are not on github" do
    Octopi::User.stub!(:find).with("user").and_return {
        raise Octopi::NotFound.new("User")
    }

    lambda {
      Repository.find_repository(@repo.user, @repo.project_name)
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should handle when repository cannot be found" do
    user = double Octopi::User
    Octopi::User.should_receive(:find).with('user').and_return(user)
    user.should_receive(:repository).with('testing').and_return {
        raise Octopi::NotFound.new("Repository")
    }

    lambda {
      Repository.find_repository(@repo.user, @repo.project_name)
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should not call github if the repository has already been saved" do
    @repo1 = Factory.create :repository, project_name: 'Repo', user: 'user'
    Octopi::User.should_not_receive(:find)
    Repository.should_receive(:where).and_return([@repo1])
    Repository.find_repository(@repo1.user, @repo1.project_name)
  end
end
