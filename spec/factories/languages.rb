Factory.sequence :language_name do |n|
  "ruby#{n.ordinalize}"
end

Factory.sequence :language_bytes do |n|
  100 + n
end

Factory.define :language do |l|
 l.name  { Factory.next :language_name } 
 l.bytes { Factory.next :language_bytes }
end
