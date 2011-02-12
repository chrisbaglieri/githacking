class RepositoriesLanguage < ActiveRecord::Base
  belongs_to :language
  belongs_to :repository
end
