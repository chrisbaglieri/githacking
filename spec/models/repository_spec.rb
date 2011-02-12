require 'spec_helper'

describe Repository do
  before do
    @repo = Factory.build :repository, name: 'testing', owner: 'user'
    stub_anonymous_user_request(login: @repo.owner)
    stub_anonymous_repo_request_from_factory(@repo)
  end

  it "should handle when users who are not on github" do
    Octopi::User.stub!(:find).with("user").and_return {
        raise Octopi::NotFound.new("User")
    }

    lambda {
      Repository.find_or_import(@repo.owner, @repo.name)
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should handle when repository cannot be found" do
    user = double Octopi::User
    Octopi::User.should_receive(:find).with('user').and_return(user)
    user.should_receive(:repository).with('testing').and_return {
        raise Octopi::NotFound.new("Repository")
    }

    lambda {
      Repository.find_or_import(@repo.owner, @repo.name)
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should not call github if the repository has already been saved" do
    Octopi::User.should_not_receive(:find)
    Repository.should_receive(:where).and_return([@repo])
    Repository.find_or_import(@repo.owner, @repo.name)
  end

  it "should handle github object to our repo translation" do
    stub_anonymous_repo_languages_request(owner: @repo.owner,
                                          name: @repo.name,
                                          languages: {'Clojure' => 123})
    
    repo = Octopi::User.find(@repo.owner).repository(@repo.name)

    @result = Repository.from_github_to_domain(repo)
    @result.languages.first.name.should == "Clojure"
    @result.languages.first.bytes.should == 123
    
    @result.attributes.should == @repo.attributes
  end

  describe "labeled_issues" do
    describe "when the issues haven't been retrieved" do
      it "should retrieve labeled issues" do
        @repo.id = 42

        index = 0

        where_clause = "issues.repository_id = (?) AND labels.name LIKE (?)"
        query_method = mock(:query_method)

        query_method.should_receive(:where) { |clause|
          clause.first.should  == where_clause
          clause.second.should == "#{@repo.id}"
          clause.third.should  == "%#{Repository::GH_TAGS[index]}%"
          index += 1
        }.exactly(4).times

        @repo.should_receive(:populate_issues).and_return(true)

        Issue.should_receive(:includes).exactly(4).times.with(:labels).
          and_return(query_method)

        @repo.labeled_issues
      end
    end
  end

  describe "#populate_issues" do
    before do
      @expected_issues = []
      @repo.should_receive(:issues).any_number_of_times.
        and_return(@expected_issues)
    end

    describe "when called" do
      describe "with issues" do
        it "should populate labels" do
          issues = {"issues" => [{"state" => "open", "labels" => ['yes']}]}
          stub_anonymous_issues_request_with_labels @repo, issues

          expected_labels = []

          issue = Issue.new

          Issue.should_receive(:build).any_number_of_times.
            and_return(issue)

          Label.should_receive(:find_or_create_by_name).any_number_of_times

          issue.should_receive(:labels).any_number_of_times.
            and_return(expected_labels)

          @repo.populate_issues

          # one issue per label
          @expected_issues.count.should == 4

          # total of 4 labels
          expected_labels.count.should == 4
        end

        it "should populate issues" do
          @repo.issues.count.should == 0

          issues = {"issues" => [{"state" => "open", "labels" => []}]}
          stub_anonymous_issues_request_with_labels @repo, issues

          @repo.populate_issues

          # one issue per label
          @expected_issues.count.should == 4
        end
      end

      it "should retrieve issues from github with our labels" do
        issues = {"issues" => []}
        stub_anonymous_issues_request_with_labels @repo, issues
        @repo.populate_issues
      end
    end
  end

  describe "#metadata" do
    describe "when meta data exists" do
      before do
        @meta_data = "blah blah blah"
        @repo.meta_data = @meta_data
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

  describe "#issues" do
    it 'should retrieve issues and organize them by tag' do
      
      @repo.issues
    end
  end

end
