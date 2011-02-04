require "spec_helper"

describe RepositoriesController do
  describe "routing" do
    it 'should route to repositories#show' do
      { get: '/someuser/somerepo' }.should route_to(controller: 'repositories',
                                                    action: 'show',
                                                    user_id: 'someuser',
                                                    id: 'somerepo')
    end

    it 'should route to repositories#edit' do
      { get: '/someuser/somerepo/edit' }.should route_to(controller: 'repositories',
                                                         action: 'edit',
                                                         user_id: 'someuser',
                                                         id: 'somerepo')
    end

    it 'should route to repositories#update' do
      { put: '/someuser/somerepo' }.should route_to(controller: 'repositories',
                                                    action: 'update',
                                                    user_id: 'someuser',
                                                    id: 'somerepo')
    end
  end
end
