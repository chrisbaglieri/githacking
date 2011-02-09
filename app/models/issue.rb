class Issue < ActiveRecord::Base
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
    new_issue = nil
    if issue["state"] == 'open'
      new_issue = OpenIssue.new
      new_issue.attributes = issue
    elsif issue["state"] == 'closed'
      new_issue = ClosedIssue.new
      new_issue.attributes = issue
    else
      # TODO: maybe throw a exception here?
    end

    new_issue
  end
end

class ClosedIssue < Issue
end

class OpenIssue < Issue
end
