module RepositoriesHelper  
  def github_repository_issues_url repo, number
    "#{github_repository_url(repo)}/issues#issue/#{number}"
  end
end
