class Repository < ActiveRecord::Base
  
  validates_uniqueness_of :name, scope: :user
  
  acts_as_taggable
  
end
