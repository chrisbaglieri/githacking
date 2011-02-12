Factory.define :open_issue do |i|
  i.gravatar_id       Digest::MD5.hexdigest("githacking")
  i.position          1
  i.number            2
  i.votes             3
  i.comments          4
  i.title             'Title of the issue'
  i.body              'This is the body of the issue'
  i.user              'someuser'
  i.state             'OpenIssue'
  i.closed_at         { Time.now }
  i.created_at_github { Time.now }
  i.updated_at_github { Time.now }
  i.repository        { |r| r.association :repository }
end

Factory.define :closed_issue do |i|
  i.gravatar_id       Digest::MD5.hexdigest("githacking")
  i.position          1
  i.number            2
  i.votes             3
  i.comments          4
  i.title             'Title of the issue'
  i.body              'This is the body of the issue'
  i.user              'someuser'
  i.state             'ClosedIssue'
  i.closed_at         { Time.now }
  i.created_at_github { Time.now }
  i.updated_at_github { Time.now }
  i.repository        { |r| r.association :repository }
end
