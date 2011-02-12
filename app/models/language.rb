class Language < ActiveRecord::Base
  has_many :repositories_languages
  has_many :repositories, :through => :repositories_languages
end
