class Repository < ActiveRecord::Base
  
  validates_uniqueness_of :name, scope: :user

  validate :verify_github_existence
  acts_as_taggable

  def metadata
    @raw ||= Curl::Easy.perform(github_repository_metadata_url)
    YAML::load(@raw.body_str)
  end

  def url
    github.url
  end
  
  def owner_url
    "http://github.com/#{github.owner}"
  end
  
  def description
    github.description
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
  end
  
  def commits
    github.commits
  end
  
  def needs
    metadata['needs']
  end
  
  def categories
    metadata['categories']
  end
  
  def desired_roles
    metadata['needs']['roles']
  end
  
  def desired_skills
    metadata['needs']['skills']
  end
  
  def mentions
    metadata['mentions']
  end
  
  def long_description
    metadata['long_description']
  end
  
  private

  def github
    @github ||= Octopi::User.find(self.user).repository(self.name)
  end
  
  def metadata
    @raw ||= Curl::Easy.perform("https://github.com/#{user}/#{name}/raw/master/githacking.yaml")
    YAML::load(@raw.body_str)
  end
  
  def verify_github_existence
    begin 
        user = Octopi::User.find(self.user)
        user.repository(self.name)
    rescue Octopi::NotFound => e
        if e.message =~ /Repository/
            self.errors.add(:name, e.message)
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
