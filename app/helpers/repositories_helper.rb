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

  HUMAN_TAGS = {'gh-bitesize' => 'Bite Size', 'gh-easy' => 'Easy', 'gh-medium' => 'Medium', 'gh-hard' => 'Hard'}
  GH_TAGS = ['gh-bitesize', 'gh-easy', 'gh-medium', 'gh-hard']

  def human_tag tag
    HUMAN_TAGS[tag]
  end
  
  def github_repository_metadata_url
    "https://github.com/#{user}/#{name}/raw/master/githacking.yaml"
  end
end
