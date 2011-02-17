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
