class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # email field is not always populated in a github account
    c.validate_email_field false
  end

  validates_presence_of :github_access_token
  
end
