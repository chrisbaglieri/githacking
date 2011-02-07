Factory.sequence :repo_name do |n|
  "Repo#{n.ordinalize}"  
end

Factory.sequence :repo_owner do |n|
  "User#{n.ordinalize}"
end

Factory.sequence :repo_url do |n|
  "http://blah.com/aaronfeng/repo#{n.ordinalize}"
end

Factory.define :repository do |r|
  r.owner        { Factory.next :repo_owner }
  r.name         { Factory.next :repo_name }
  r.url          { Factory.next :repo_url }
  r.description  "Best ever"
  r.private       false
  r.has_wiki      false
  r.homepage     "http://homepage.com"
  r.watchers      20
  r.forks         2
  r.fork          false
  r.open_issues   10
  r.has_issues    false
  r.has_downloads false
  r.source        '' # "source/source"
  r.parent        '' # "parent/repo"
  r.languages     { |languages| [languages.association(:language),
                                 languages.association(:language)] }
end
