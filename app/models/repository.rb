class Repository < ActiveRecord::Base
  
  validates_uniqueness_of :name, scope: :user
  
  acts_as_taggable

  def github
    @github ||= Octopi::User.find(self.user).repository(self.name)
  end
end
