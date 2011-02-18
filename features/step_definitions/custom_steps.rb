Before do
    activate_authlogic
end

Given /^I log in as "([^\"]*)"$/ do |username|
   @user = Factory.create :user, login: username
   UserSession.create @user
end

Given /^We need to show github user "([^\"]+)"$/ do |username|
    stub_anonymous_user_request login: username
end

Given /^We need an anonymous repo "([^\"]+)" by "([^\"]+)"$/ do |repo, username|
  stub_anonymous_repo_request owner: username, name: repo
  stub_anonymous_repo_languages_request owner: username, name: repo
end

Then /^there should be a saved repo "([^\"]+)" by "([^\"]+)"$/ do |repo, username|
  Repository.where(name: repo, owner: username).first.should_not be_nil
end

Given /^there is a repository "([^\"]*)" by "([^\"]*)"$/ do |repo, username|
   Factory.create :repository, owner: username, name: repo 
end

Given /^there is no repository "([^\"]*)" by "([^\"]*)" on GitHub$/ do |repo, username|
  puts repo
  puts username
  stub_missing_repo_request owner: username, name: repo
end
