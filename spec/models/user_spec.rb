require 'spec_helper'

describe User do

  [:login, :github_access_token].each do |field|
    it 'should require #{field} on create' do
      Factory.build(:user, field => nil).save.should be_false
    end
  end
  
  it 'should pull back public repositories from github on repositories' do
    user = Factory.build(:user)
    repo = Factory.build :repository, owner: user.login

    Repository.should_receive(:from_github_to_domain).and_return(repo)

    stub_github_requests_for repo
    stub_anonymous_repos_request(owner: user.login)

    user.repositories.count.should == 1
  end
  
end
