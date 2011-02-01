require 'spec_helper'

describe UsersController do

  describe 'POST :create' do
    it 'should create a user with oAuth2' do
      code = 'codedoesntmatter'
      result = double Object
      token = 'tokendoesntmatter'
      result.should_receive(:body_str).and_return("access_token=#{token}")
      Curl::Easy.should_receive(:http_post).with('https://github.com/login/oauth/access_token', 'client_id=' + Github.config[:client_id] + '&redirect_uri=' + Github.config[:redirect_uri] + '&client_secret=' + Github.config[:secret] + '&code=' + code).and_return(result)

      get_result = double Object
      email = 'some@email.com'
      gravatar_id = 'gravatariddoesntmatter'
      login = 'somelogin'
      user_data = {email: email, gravatar_id: gravatar_id, login: login}
      get_result.should_receive(:body_str).and_return("{\"user\": #{user_data.to_json}}")
      Curl::Easy.should_receive(:http_get).with('https://github.com/api/v2/json/user/show?access_token=' + token).and_return(get_result)
      
      post :create, code: code

      u = User.last
      u.email.should == email
      u.gravatar_id.should == gravatar_id
      u.login.should == login
      u.github_access_token.should == token
    end

    it 'should create a user with oAuth2 even if an email is not provided' do
      code = 'codedoesntmatter'
      result = double Object
      token = 'tokendoesntmatter'
      result.should_receive(:body_str).and_return("access_token=#{token}")
      Curl::Easy.should_receive(:http_post).with('https://github.com/login/oauth/access_token', 'client_id=' + Github.config[:client_id] + '&redirect_uri=' + Github.config[:redirect_uri] + '&client_secret=' + Github.config[:secret] + '&code=' + code).and_return(result)

      get_result = double Object
      gravatar_id = 'gravatariddoesntmatter'
      login = 'somelogin'
      user_data = {gravatar_id: gravatar_id, login: login}
      get_result.should_receive(:body_str).and_return("{\"user\": #{user_data.to_json}}")
      Curl::Easy.should_receive(:http_get).with('https://github.com/api/v2/json/user/show?access_token=' + token).and_return(get_result)
      
      post :create, code: code

      u = User.last
      u.email.should == nil
      u.gravatar_id.should == gravatar_id
      u.login.should == login
      u.github_access_token.should == token
    end

    
    it 'should create a user with oAuth2 even without a gravatar' do
      code = 'codedoesntmatter'
      result = double Object
      token = 'tokendoesntmatter'
      result.should_receive(:body_str).and_return("access_token=#{token}")
      Curl::Easy.should_receive(:http_post).with('https://github.com/login/oauth/access_token', 'client_id=' + Github.config[:client_id] + '&redirect_uri=' + Github.config[:redirect_uri] + '&client_secret=' + Github.config[:secret] + '&code=' + code).and_return(result)

      get_result = double Object
      email = 'some@email.com'
      login = 'somelogin'
      user_data = {email: email, login: login}
      get_result.should_receive(:body_str).and_return("{\"user\": #{user_data.to_json}}")
      Curl::Easy.should_receive(:http_get).with('https://github.com/api/v2/json/user/show?access_token=' + token).and_return(get_result)
      
      post :create, code: code

      u = User.last
      u.email.should == email
      u.login.should == login
      u.github_access_token.should == token
    end

    it 'should log the user in if the user exists' do
      code = 'codedoesntmatter'
      result = double Object
      token = 'tokendoesntmatter'
      result.should_receive(:body_str).and_return("access_token=#{token}")
      Curl::Easy.should_receive(:http_post).with('https://github.com/login/oauth/access_token', 'client_id=' + Github.config[:client_id] + '&redirect_uri=' + Github.config[:redirect_uri] + '&client_secret=' + Github.config[:secret] + '&code=' + code).and_return(result)

      get_result = double Object
      email = 'some@email.com'
      gravatar_id = 'gravatariddoesntmatter'
      login = 'somelogin'
      user_data = {email: email, gravatar_id: gravatar_id, login: login}
      get_result.should_receive(:body_str).and_return("{\"user\": #{user_data.to_json}}")
      Curl::Easy.should_receive(:http_get).with('https://github.com/api/v2/json/user/show?access_token=' + token).and_return(get_result)
      
      Factory.create :user, email: email
      UserSession.should_receive(:create)
      
      post :create, code: code

    end

    
    it 'should not create a user and give a reasonable error if github does not respond' do
      code = 'codedoesntmatter'
      result = double Object
      token = 'tokendoesntmatter'
      result.should_receive(:body_str).and_return("")
      Curl::Easy.should_receive(:http_post).with('https://github.com/login/oauth/access_token', 'client_id=' + Github.config[:client_id] + '&redirect_uri=' + Github.config[:redirect_uri] + '&client_secret=' + Github.config[:secret] + '&code=' + code).and_return(result)

      post :create, code: code

      response.should be_redirect
    end
    
  end
  
end
