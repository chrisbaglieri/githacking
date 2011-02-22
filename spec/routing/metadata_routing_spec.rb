require 'spec_helper'

describe MetadataController do
  describe 'routing' do
    ['edit', 'new'].each do |action|
      it "should route to #{action} metadata" do
        { get: "/user/repo/metadata/#{action}" }.should route_to(controller: 'metadata',
                                                                 action: action,
                                                                 user_id: 'user',
                                                                 repository_id: 'repo')
      end
    end
    it 'should route to create metadata' do
      { post: '/user/repo/metadata' }.should route_to(controller: 'metadata',
                                                      action: 'create',
                                                      user_id: 'user',
                                                      repository_id: 'repo')
    end
  end
end
