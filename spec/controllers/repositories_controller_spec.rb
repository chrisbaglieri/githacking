require 'spec_helper'

describe RepositoriesController do

  before do
    @r = Factory.build :repository
    stub_github_requests_for @r
    @r.save
  end
  
  describe "GET show" do
    it "assigns the requested repository as @repository" do
      get :show, id: @r.name, user_id: @r.owner
      assigns(:repository).id.should == @r.id
    end

  end

  # TODO: Redo with issues fixtures once issues persisting is in.
  describe "GET issues" do
    before do
      Repository.should_receive(:find_or_import).and_return(@r)
    end
    it 'assigns the issues for the repository for the given tag' do
      @r.should_receive(:issues).and_return('easy' => [1,2,3], 'medium' => ['a','b','c'])
      get :issues, repository_id: @r.name, user_id: @r.owner, tag: 'easy'
      assigns(:tag).should == 'easy'
      assigns(:issues).should == [1,2,3]
    end
    it 'should redirect if the tag isn\'t a githacking tracked tag' do
      get :issues, repository_id: @r.name, user_id: @r.owner, tag: 'notagithackingtag'
      response.should be_redirect
    end
  end

end
