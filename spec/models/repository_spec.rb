require 'spec_helper'

describe Repository do
  before do
    @repo = Factory.build :repository, project_name: 'testing', owner: 'user'
  end

  it "should handle when users who are not on github" do
    Octopi::User.stub!(:find).with("user").and_return {
        raise Octopi::NotFound.new("User")
    }

    lambda {
      Repository.find_repository(@repo.owner, @repo.project_name)
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should handle when repository cannot be found" do
    user = double Octopi::User
    Octopi::User.should_receive(:find).with('user').and_return(user)
    user.should_receive(:repository).with('testing').and_return {
        raise Octopi::NotFound.new("Repository")
    }

    lambda {
      Repository.find_repository(@repo.owner, @repo.project_name)
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should not call github if the repository has already been saved" do
    Octopi::User.should_not_receive(:find)
    Repository.should_receive(:where).and_return([@repo])
    Repository.find_repository(@repo.owner, @repo.project_name)
  end

  it "should handle github object to our repo translation" do
    stub_anonymous_user_request(login: 'someuser')
    stub_anonymous_repo_request(owner: 'someuser', name: 'somerepo')
    stub_anonymous_repo_languages_request(owner: 'someuser', name: 'somerepo', languages: {'Clojure' => 123})
    repo = Octopi::User.find('someuser').repository('somerepo')

    @result = Repository.from_github_to_domain(repo)
    @result.languages.first.name.should == "Clojure"
    @result.languages.first.bytes.should == 123
  end
end
