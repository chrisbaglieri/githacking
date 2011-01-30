module RepoWeights
    def self.get_commits_weight(username, repo)
        commits = Curl::Easy.perform("http://github.com/api/v2/json/commits/list/#{username}/#{repo}/master")
        commits = JSON.parse(commits.body_str)["commits"]
        commits = commits.reject { |p|
            30.days.ago > (DateTime.parse(p['committed_date']))
        }
        return commits.length*0.65
    end

    def self.get_pulls_weight(username, repo)
        rails = Curl::Easy.perform("http://github.com/api/v2/json/pulls/#{username}/#{repo}")
        rails_pulls = JSON.parse(rails.body_str)["pulls"]
        rails_pulls = rails_pulls.reject { |p|
            30.days.ago > (DateTime.parse(p['updated_at']))
        }
        return rails_pulls.length*0.25
    end

    def self.get_issue_weights(username, repo)
        rissues = Curl::Easy.perform("http://github.com/api/v2/json/issues/list/#{username}/#{repo}/open")
        rails_issues = JSON.parse(rissues.body_str)["issues"]
        rails_issues = rails_issues.reject { |p|
            30.days.ago > (DateTime.parse(p['updated_at']))
        }
        return rails_issues.length*0.15
    end

    def self.get_collab_weights(username, repo)
        collabs = Curl::Easy.perform("http://github.com/api/v2/json/repos/show/#{username}/#{repo}/collaborators")
        rails_collabs = JSON.parse(collabs.body_str)
        return rails_collabs["collaborators"].length*0.05
    end

    def self.get_contrib_weights(username, repo)
        contribs = Curl::Easy.perform("http://github.com/api/v2/json/repos/show/#{username}/#{repo}/contributors")
        rails_contribs = JSON.parse(contribs.body_str)
        return rails_contribs["contributors"].length*0.05
    end

    def self.get_weights(username, repo)
        return get_commits_weight(username,repo) + get_pulls_weight(username, repo) + get_issue_weights(username, repo) + get_collab_weights(username, repo) + get_contrib_weights(username, repo)
    end 
end
