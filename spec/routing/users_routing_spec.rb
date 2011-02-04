require 'spec_helper'

describe UsersController do
  describe 'routing' do
    it 'should route to #show' do
      { get: '/someuser' }.should route_to(controller: 'users',
                                           action: 'show',
                                           id: 'someuser')
    end
  end
end
