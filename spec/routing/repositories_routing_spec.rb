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
end
