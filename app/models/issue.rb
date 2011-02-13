class Issue < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  belongs_to :repository
  has_many   :labels_tags
  has_many   :labels, :through => :labels_tags

  set_inheritance_column 'state'

  def created_at=(datetime)
    self.created_at_github = datetime
  end

  def updated_at=(datetime)
    self.updated_at_github = datetime
  end

  def self.build(issue)
    state = issue.delete "state"
    new_issue = nil

    if state == 'open'
      new_issue = OpenIssue.new
      new_issue.attributes = issue
    elsif state == 'closed'
      new_issue = ClosedIssue.new
      new_issue.attributes = issue
    else
      raise 'State must be open or closed'
    end

    new_issue
  end

  def distance_in_the_past
    diff = Time.now.to_i - self.created_at.to_i
    
    quantity, unit = case
                     when diff > 1.day
                       [diff / 1.day.to_i, 'day']
                     when diff > 1.hour
                       [diff / 1.hour.to_i, 'hour']
                     when diff > 1.minute
                       [diff / 1.minute.to_i, 'minute']
                     when diff > 1.second
                       [diff / 1.second.to_i, 'second']
                     else
                       [diff, 'milisecond']
                     end
    "#{pluralize(quantity, unit)} ago"
  end
  
end

class ClosedIssue < Issue
end

class OpenIssue < Issue
end
