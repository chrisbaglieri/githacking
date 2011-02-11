require 'spec_helper'

describe RepositoriesController do

  before do
    request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("githacker:point65")

    @r = Factory.build :repository
    stub_github_requests_for @r
    @r.save
  end
  
  describe "GET show" do
    it "assigns the requested repository as @repository" do
      Repository.should_receive(:find_repository).with(@r.owner, @r.name).and_return(@r)

      get :show, id: @r.name, user_id: @r.owner
      assigns(:repository).id.should == @r.id
    end

  end

end
