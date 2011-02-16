module RepositoriesHelper
  def github_repository_issues_url repo, number = 0
    if number > 0
      "#{repo.url}/issues#issue/#{number}"
    else
      "#{repo.url}/issues"
    end
  end
end
