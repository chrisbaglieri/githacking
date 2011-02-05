class Repository < ActiveRecord::Base
  serialize :meta_data
  
  validates_presence_of :project_name
  validates_uniqueness_of :project_name, scope: :user

  acts_as_taggable
  
  def owner_url
    "http://github.com/#{user}"
  end
  
  def languages
    # TODO: FIXME
    #github.languages
  end
  
  def issues
    @issues = {}
    GH_TAGS.each do |tag|
        github.issues.reject { |issue| !issue.labels.include?(tag) }.each do |issue|
        @issues[tag] ||= []
        @issues[tag] << issue
      end
    end
    return @issues
  rescue 
  {}
  end
  
  def commits
    # TODO: FIXME
    #github.commits
  end
  
  def needs
    metadata['needs']
  rescue 
  []
  end
  
  def categories
    metadata['categories']
  rescue 
  []
  end
  
  def desired_roles
    metadata['needs']['roles']
  rescue 
  []
  end
  
  def desired_skills
    metadata['needs']['skills']
  rescue 
  []
  end
  
  def mentions
    metadata['mentions']
  rescue 
  []
  end
  
  def long_description
    metadata['long_description']
  rescue 
  nil
  end
  
  def self.from_github_to_domain(github_repo)
    repository              = Repository.new
    repository.url          = github_repo.url
    repository.homepage     = github_repo.homepage
    repository.watchers     = github_repo.watchers
    repository.forks        = github_repo.forks
    repository.fork         = github_repo.fork
    repository.private      = github_repo.private
    repository.open_issues  = github_repo.open_issues
    repository.owner        = github_repo.owner
    repository.description  = github_repo.description
    repository.name         = github_repo.name
    repository.project_name = github_repo.name #TODO: remove me
    repository.source       = "" #TODO: fixme
    repository.parent       = "" #TODO: fixme

    # pushed_at
    # private
    # created_at # this is diff from this table's created_at
    # has_wiki
    # has_downloads
    # has_issues

    repository
  end

  def self.find_repository(github_user_id, project_name)
    repository = Repository.where(:url => "https://github.com/#{github_user_id}/#{project_name}").first

    if not repository
      begin
        grepo = Octopi::User.find(github_user_id).repository(project_name)

        # TODO: should do some error checking here
        repository = from_github_to_domain(grepo)
        repository.user = github_user_id #TODO:not sure what this is for
        repository.save

      rescue Octopi::NotFound => e
        raise ActiveRecord::RecordNotFound
      end
    end
    repository
  end
  
  def metadata
    if !self.meta_data
      raw = Curl::Easy.perform("https://github.com/#{user}/#{project_name}/raw/master/githacking.yaml")
      if raw.header_str =~ /200 OK/
        y = YAML::load(raw.body_str)
        self.meta_data = y
        save
      end
    end

    self.meta_data
  end
  
  HUMAN_TAGS = {'gh-bitesize' => 'Bite Size', 'gh-easy' => 'Easy', 'gh-medium' => 'Medium', 'gh-hard' => 'Hard'}
  GH_TAGS = ['gh-bitesize', 'gh-easy', 'gh-medium', 'gh-hard']
  
  def self.human_tag tag
    HUMAN_TAGS[tag]
  end

end
