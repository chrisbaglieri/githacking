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
    Octopi::User.should_not_receive(:find)
    Repository.should_receive(:where).and_return([@repo])
    Repository.find_repository(@repo.user, @repo.project_name)
  end

  it "should handle github object to our repo translation" do
    repo = double Octopi::Repository
    repo.should_receive(:url).and_return(@repo.url)
    repo.should_receive(:homepage).and_return(@repo.homepage)
    repo.should_receive(:watchers).and_return(@repo.watchers)
    repo.should_receive(:forks).and_return(@repo.forks)
    repo.should_receive(:fork).and_return(@repo.fork)
    repo.should_receive(:private).and_return(@repo.private)
    repo.should_receive(:open_issues).and_return(@repo.open_issues)
    repo.should_receive(:owner).and_return(@repo.owner)
    repo.should_receive(:description).and_return(@repo.description)
    repo.should_receive(:name).and_return(@repo.name)
    repo.should_receive(:project_name).and_return(@repo.project_name)
    repo.should_receive(:source).and_return(@repo.source)
    repo.should_receive(:parent).and_return(@repo.parent)
    repo.should_receive(:languages).and_return({"Clojure" => 123})

    @result = Repository.from_github_to_domain(repo)
    @result.languages.first.name.should == "Clojure"
    @result.languages.first.bytes.should == 123
  end
end
