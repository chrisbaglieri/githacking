require 'spec_helper'

describe RepositoriesController do

  before do
    request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("githacker:point65")

    @r = Factory.build :repository
    stub_anonymous_user_request login: @r.owner
    stub_anonymous_repo_request_from_factory @r
    stub_anonymous_repo_languages_request owner: @r.owner, name: @r.name
    @r.save
  end
  
  describe "GET show" do
    it "assigns the requested repository as @repository" do
      get :show, id: @r.name, user_id: @r.owner
      assigns(:repository).id.should == @r.id
    end

  end

  describe "GET issues" do
    before do
      Repository.should_receive(:find_or_import).and_return(@r)
    end
    it 'assigns the issues for the repository for the given tag' do
      issues = Array.new(4).collect { Factory.create :open_issue, repository: @r }
      issues.collect { |i| i.labels.create(name: 'easy') }
      get :issues, repository_id: @r.name, user_id: @r.owner, tag: 'easy'
      assigns(:tag).should == 'easy'
      assigns(:issues).size.should == 4
      assigns(:issues).collect(&:id).should == issues.collect(&:id)
    end
    it 'should redirect if the tag isn\'t a githacking tracked tag' do
      get :issues, repository_id: @r.name, user_id: @r.owner, tag: 'notagithackingtag'
      response.should be_redirect
    end
  end

end
