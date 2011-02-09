class Issue < ActiveRecord::Base
  belongs_to :repository

  set_inheritance_column 'state'
end

class ClosedIssue < Issue
end

class OpenIssue < Issue
end
