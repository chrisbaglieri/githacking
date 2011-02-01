Factory.sequence :repo_name do |n|
  "Repo#{n.ordinalize}"  
end

Factory.sequence :repo_user do |n|
  "User#{n.ordinalize}"
end

Factory.define :repository do |r|
  r.user { Factory.next :repo_user }
  r.project_name { Factory.next :repo_name }
end
