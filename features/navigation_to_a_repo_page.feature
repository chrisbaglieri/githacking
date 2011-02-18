Feature: Navigating to a Repository page
    This covers all the different scenarios that will occur while we are
    navigating to our repository pages.
    
    Background:
        Given We need to show github user "codingjester"
        Given We need an anonymous repo "pyImgur" by "codingjester"
        Given We need an anonymous repo "twixrforkids" by "buntingsan"
    
    Scenario: Without repository existing.
        Given I log in as "test_user"
        When I go to "codingjester/pyImgur"
        Then I should see "codingjester"
        And I should see "pyImgur"
        And there should be a saved repo "pyImgur" by "codingjester"

    Scenario: With repository existing.
       Given there is a repository "twixrforkids" by "buntingsan" 
       When I go to "buntingsan/twixrforkids"
       Then I should see "buntingsan"
       And I should see "twixrforkids"
       And there should be a saved repo "twixrforkids" by "buntingsan"

    Scenario: with repository not existing on github
        Given I log in as "test_user"
        Given there is no repository "asdfg6" by "codingjester" on GitHub
        When I go to "codingjester/asdfg6"
        And show me the page
