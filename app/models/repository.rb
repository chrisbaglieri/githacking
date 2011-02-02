class Repository < ActiveRecord::Base
  
  validates_presence_of :project_name
  validates_uniqueness_of :project_name, scope: :user

  validate :verify_github_existence
  acts_as_taggable
  
  scope :owned_by, lambda { |user| where(:user => user.login) }

  def metadata
    @raw ||= Curl::Easy.perform(github_repository_metadata_url)
    YAML::load(@raw.body_str)
  end

  def url
    github.url
  end
  
  def owner_url
    "http://github.com/#{user}"
  end
  
  def description
    github.description
  end

  def languages
    github.languages
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
    github.commits
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
  
  def github
    @github ||= Octopi::User.find(self.user).repository(self.project_name)
  end
  
  def metadata
    @raw ||= Curl::Easy.perform("https://github.com/#{user}/#{project_name}/raw/master/githacking.yaml")
    YAML::load(@raw.body_str)
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
