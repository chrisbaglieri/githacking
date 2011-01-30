class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validate_email_field false
  end

  validate :check_api_key

  def check_api_key
    # TODO: verify key on save
  end
  
end
