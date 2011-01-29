class Repository < ActiveRecord::Base
  
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

  def github
    @github ||= Octopi::User.find(self.user).repository(self.name)
  end
end
