class Label < ActiveRecord::Base
  has_many :labels_tags
  has_many :issues, :through => :labels_tags
end
