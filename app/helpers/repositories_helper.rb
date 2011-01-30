module RepositoriesHelper  
  def github_repository_issues_url repo, number
    "#{repo.url}/issues#issue/#{number}"
  end
end
