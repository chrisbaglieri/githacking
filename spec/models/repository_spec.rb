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

  it "should handle github object to our repo translation" do
    @result = Repository.from_github_to_domain(@repo)  
    @result.url.should          == @repo.url  
    @result.homepage.should     == @repo.homepage
    @result.watchers.should     == @repo.watchers
    @result.forks.should        == @repo.forks
    @result.fork.should         == @repo.fork
    @result.private.should      == @repo.private
    @result.open_issues.should  == @repo.open_issues
    @result.owner.should        == @repo.owner
    @result.description.should  == @repo.description
    @result.name.should         == @repo.name
    @result.project_name.should == @repo.name #TODO: remove me
    @result.source.should       == "" #TODO: fixme
    @result.parent.should       == "" #TODO: fixme
  end
end
