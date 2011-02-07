require 'spec_helper'

describe Repository do
  before do
    @repo = Factory.build :repository, name: 'testing', owner: 'user'
  end

  it "should handle when users who are not on github" do
    Octopi::User.stub!(:find).with("user").and_return {
        raise Octopi::NotFound.new("User")
    }

    lambda {
      Repository.find_repository(@repo.owner, @repo.name)
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should handle when repository cannot be found" do
    user = double Octopi::User
    Octopi::User.should_receive(:find).with('user').and_return(user)
    user.should_receive(:repository).with('testing').and_return {
        raise Octopi::NotFound.new("Repository")
    }

    lambda {
      Repository.find_repository(@repo.owner, @repo.name)
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should not call github if the repository has already been saved" do
    Octopi::User.should_not_receive(:find)
    Repository.should_receive(:where).and_return([@repo])
    Repository.find_repository(@repo.owner, @repo.name)
  end

  it "should handle github object to our repo translation" do
    stub_anonymous_user_request(login: @repo.owner)
    stub_anonymous_repo_request_from_factory(@repo)
    stub_anonymous_repo_languages_request(owner: @repo.owner,
                                          name: @repo.name,
                                          languages: {'Clojure' => 123})
    
    repo = Octopi::User.find(@repo.owner).repository(@repo.name)

    @result = Repository.from_github_to_domain(repo)
    @result.languages.first.name.should == "Clojure"
    @result.languages.first.bytes.should == 123
    
    @result.attributes.should == @repo.attributes
  end

  describe "metadata" do
    describe "when meta data exists" do
      before do
        @meta_data = "blah blah blah"
        @repo.meta_data = @meta_data
        @repo.save
      end

      it "should not call github or save meta data" do
        # webmock is used, so it will blow up if tried to use a real http call
        @repo.should_not_receive(:save)

        @repo.metadata
      end
    end

    describe "when meta data doesn't exists" do
      it "should save meta data into database" do
        @repo.meta_data.should == nil

        stub_metadata_request @repo.owner, @repo.name
        @repo.should_receive(:save)

        @repo.metadata
        @repo.meta_data.should_not == nil
      end
    end
  end

end
