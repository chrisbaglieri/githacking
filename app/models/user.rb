class User < ActiveRecord::Base
  include Gravtastic
  gravtastic

  acts_as_authentic do |c|
    # email field is not always populated in a github account
    c.validate_email_field false
  end

  validates_presence_of :github_access_token
  
  def repositories(load_associations=true)
    return @repository_stubs if defined?(@repository_stubs)
    @repository_stubs = []
    Octopi::User.find(self.login).repositories.each do |remote_repository|
      # build local repos, don't bother loading languages
      @repository_stubs << Repository.from_github_to_domain(remote_repository, load_associations)
    end
    @repository_stubs
  end
end
