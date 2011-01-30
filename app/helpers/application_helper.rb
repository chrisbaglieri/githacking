module ApplicationHelper
  def github_login_url
    "https://github.com/login/oauth/authorize?client_id=#{GITHUB[:client_id]}&redirect_uri=#{GITHUB[:redirect_uri]}"
  end
end
