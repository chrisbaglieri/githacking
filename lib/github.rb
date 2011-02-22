module Github
  MAX_REPOS_PAGE = 30
  
  def self.repo_url user, repo
    "http://github.com/api/v2/json/repos/show/#{user}/#{repo}"
  end

  def self.repos_url user, page=1
    "https://github.com/api/v2/json/repos/show/#{user}?page=#{page}"
  end
  
  def self.languages_url user, repo
    "http://github.com/api/v2/json/repos/show/#{user}/#{repo}/languages"
  end

  def self.user_url login
    "http://github.com/api/v2/json/user/show/#{login}"
  end

  def self.user login
    result = curl self.user_url(login)

    handle_error result

    result["user"]
  end

  def self.languages user, repo
    result = curl self.languages_url(user, repo)

    handle_error result

    result["languages"]
  end

  def self.repository user, repo
    result = curl self.repo_url(user, repo)

    handle_error result

    result["repository"]
  end

  def self.repositories user
    result_repos = []
    page = 1
  
    begin
      result = curl self.repos_url(user, page)
  
      self.handle_error result
  
      result_repos.concat result["repositories"]
      page += 1
    end while (result["repositories"] and result["repositories"].count == MAX_REPOS_PAGE)
  
    result_repos
  end

  def self.handle_error result
    if result["error"]
      raise result["error"]
    end
  end

  def self.curl url
    JSON.parse(Curl::Easy.perform(url).body_str)
  end
end
