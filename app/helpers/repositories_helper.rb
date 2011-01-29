module RepositoriesHelper
  def github_user_url repo
    "http://github.com/#{repo.user}"
  end
  
  def github_repository_url repo
    "#{github_user_url(repo)}/#{repo.name}"
  end

  def github_repository_issues_url repo, number
    "#{github_repository_url(repo)}/issues#issue/#{number}"
  end
end
