class Repository < ActiveRecord::Base
  validates_uniqueness_of :name, scope: :user

  validate :verify_github_exhistence

  def verify_github_exhistence
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
end
