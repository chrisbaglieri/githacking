Factory.define :issue do |i|
  i.gravatar_id Digest::MD5.hexdigest("githacking")
  i.position          1
  i.number            2
  i.votes             3
  i.comments          4
  i.title             'githacking'
  i.body              'super githacking'
  i.user              'testuser'
  i.state             'open'
  i.closed_at         Time.now
  i.created_at_github Time.now
  i.updated_at_github Time.now
  i.repository_id     1
end
