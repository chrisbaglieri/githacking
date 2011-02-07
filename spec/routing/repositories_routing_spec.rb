require "spec_helper"

describe RepositoriesController do
  describe "routing" do
    it 'should route to repositories#show' do
      { get: '/someuser/somerepo' }.should route_to(controller: 'repositories',
                                                    action: 'show',
                                                    user_id: 'someuser',
                                                    id: 'somerepo')
    end
  end

  it 'should route to repositories#issues' do
    { get: '/someuser/somerepo/issues' }.should route_to(controller: 'repositories',
                                                         action: 'issues',
                                                         user_id: 'someuser',
                                                         repository_id: 'somerepo')
  end

  it 'should route to repositories#issues with tag' do
    { get: '/someuser/somerepo/issues/tag' }.should route_to(controller: 'repositories',
                                                             action: 'issues',
                                                             user_id: 'someuser',
                                                             repository_id: 'somerepo',
                                                             tag: 'tag')
  end
end
