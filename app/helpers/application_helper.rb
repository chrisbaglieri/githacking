module ApplicationHelper
  def github_login_url
    "https://github.com/login/oauth/authorize?client_id=#{Github.config[:client_id]}&redirect_uri=#{Github.config[:redirect_uri]}"
  end
  
  def local_repository_path repo
    "/#{repo.owner}/#{repo.name}"
  end
  
  def local_repository_issues_path repo
    "#{local_repository_path(repo)}/issues"
  end
end
