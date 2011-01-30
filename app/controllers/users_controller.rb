class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def create
    url = 'https://github.com/login/oauth/access_token'
    query = 'client_id=' + GITHUB[:client_id] + '&redirect_uri=' + GITHUB[:redirect_uri] + '&client_secret=' + GITHUB[:secret] + '&code=' + params[:code]
    token = Curl::Easy.http_post(url, query).body_str.split(/=/)[1]
    
    url = 'https://github.com/api/v2/json/user/show?access_token=' + token
    data = JSON::parse(Curl::Easy.http_get(url).body_str)['user']

    @user = User.where(email: data['email']).first

    # Login if the user exists
    unless @user.nil?
      @user_session = UserSession.create(@user)
      redirect_back_or_default(account_url)
      return
    end

    @user = User.new(login: data['login'], email: data['email'], github_access_token: token, gravatar_id: data['gravatar_id'])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
