class Repository < ActiveRecord::Base
  validates_uniqueness_of :name, scope: :user
end
