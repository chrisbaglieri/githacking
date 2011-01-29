class Repository < ActiveRecord::Base

  include RepositoriesHelper
  
  validates_uniqueness_of :name, scope: :user

  validate :verify_github_existence
  acts_as_taggable

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

  def github
    @github ||= Octopi::User.find(self.user).repository(self.name)
  end
  
  def metadata
    @raw ||= Curl::Easy.perform(github_repository_metadata_url)
    YAML::load(@raw.body_str)
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

end
