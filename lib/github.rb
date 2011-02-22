module Github
  MAX_REPOS_PAGE = 30
  
  def self.repos_url user, page=1
    "https://github.com/api/v2/json/repos/show/#{user}?page=#{page}"
  end
  
  def self.repositories(user)
    result_repos = []
    page = 1
  
    begin
      result = JSON.parse(Curl::Easy.perform(self.repos_url(user, page)).body_str)
  
      if result["error"]
        puts result["error"]
        puts "handle error here"
        return
      end
  
      result_repos.concat result["repositories"]
      page += 1
    end while (result["repositories"] and result["repositories"].count == MAX_REPOS_PAGE)
  
    result_repos
  end
end
