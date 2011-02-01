module ApplicationHelper
  def github_login_url
    "https://github.com/login/oauth/authorize?client_id=#{Github.config[:client_id]}&redirect_uri=#{Github.config[:redirect_uri]}"
  end
end
