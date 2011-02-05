class Repository < ActiveRecord::Base
  serialize :meta_data
  
  validates_presence_of :project_name
  validates_uniqueness_of :project_name, scope: :user

  # TOD: fix me
  #validate :verify_github_existence
  acts_as_taggable
  
  scope :owned_by,  lambda { |user| where(:user => user.login) }

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
  
  def self.find_repository(github_user_id, project_name)
    repository = Repository.where(:url => "https://github.com/#{github_user_id}/#{project_name}").first

    if not repository
      grepo                  = Octopi::User.find(github_user_id).repository(project_name)
      repository             = Repository.new
      repository.url         = grepo.url
      repository.homepage    = grepo.homepage
      repository.watchers    = grepo.watchers
      repository.forks       = grepo.forks
      repository.fork        = grepo.fork
      repository.private     = grepo.private
      repository.open_issues = grepo.open_issues
      repository.owner       = grepo.owner
      repository.description = grepo.description
      repository.name        = grepo.name
      repository.user        = github_user_id #TODO:not sure what this is for
      repository.project_name = grepo.name #TODO: remove me
      repository.source      = "" #TODO: fixme
      repository.parent      = "" #TODO: fixme

      # TODO: should do some error checking here
      repository.save

      # pushed_at
      # private
      # created_at # this is diff from this table's created_at
      # has_wiki
      # has_downloads
      # has_issues
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
  
  def verify_github_existence
    begin 
        user = Octopi::User.find(self.user)
        user.repository(self.project_name)
    rescue ArgumentError => e
        if e.message =~ /User/
            self.errors.add(:user, "cannot be empty")
        end
    rescue Octopi::NotFound => e
        if e.message =~ /Repository/
            self.errors.add(:project_name, e.message)
        elsif e.message =~ /User/
            self.errors.add(:user, e.message)
        end
    end
  end
  
  HUMAN_TAGS = {'gh-bitesize' => 'Bite Size', 'gh-easy' => 'Easy', 'gh-medium' => 'Medium', 'gh-hard' => 'Hard'}
  GH_TAGS = ['gh-bitesize', 'gh-easy', 'gh-medium', 'gh-hard']
  
  def self.human_tag tag
    HUMAN_TAGS[tag]
  end

end
