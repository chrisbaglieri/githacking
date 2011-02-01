Factory.sequence :login do |n|
  "#{n.ordinalize}user"
end

Factory.sequence :email do |n|
  "#{n.ordinalize}@email.com"
end

Factory.define :user do |u|
  u.login { Factory.next :login }
  u.gravatar_id 'someidthatisamd5hashofemail'
  u.email { Factory.next :email }
  u.github_access_token 'somegithubaccesstoken'
end
