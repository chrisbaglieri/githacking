module RepositoriesHelper
  def github_repository_issues_url repo, number = 0
    if number > 0
      "#{repo.url}/issues#issue/#{number}"
    else
      "#{repo.url}/issues"
    end
  end
  
  def local_path repo
    "/#{repo.owner}/#{repo.name}"
  end
  
  def local_issues_path repo
    "#{local_path(repo)}/issues"
  end
end
