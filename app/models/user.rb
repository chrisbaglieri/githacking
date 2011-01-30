class User < ActiveRecord::Base
  acts_as_authentic

  validate :check_api_key
  
  def to_key
     new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

  def check_api_key
    # TODO: verify key on save
  end
  
end
