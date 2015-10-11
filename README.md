# StackTwitter

### Description

StackTwitter is a Rails app that displays the 25 most recent tweets for any given Twitter handle. A few tools used

* [Twitter](https://github.com/sferik/twitter) gem for consuming the [Twitter API](https://dev.twitter.com/docs/api)

* [Devise](https://github.com/plataformatec/devise) gem for a user authentication

* [Rspec Rails](https://github.com/rspec/rspec-rails), [Faker](https://github.com/stympy/faker), [Factory Girl](https://github.com/thoughtbot/factory_girl), [Capybara](https://github.com/jnicklas/capybara), [Selenium WebDriver](http://www.seleniumhq.org/projects/webdriver/) for creating feature tests

### Demo

Please visit the [Heroku App](http://stacktwitter.herokuapp.com/) for a live demo

### Setup

1. Clone the git repo into local computer

1. Run `rake db:development:refresh`

1. Run `rails s`

1. Go to `http://localhost:3000`

1. Create a new account with the web UI

### Tests

Run `bundle exec rspec spec/features/*`

The following feature tests have been created

* Given a signed in user, if he visits '/', then he should see the tweets page

* Given a signed in user, if he visits '/', then he should see the Sign In page

* Given valid data, a user should be able to sign up

* Given valid credentials, a user should be able to sign in

* Given a sign in user, when the user visits the tweets page, it should be empty by default

* Given a sign in user, when the user visits the tweets page and submits a valid handle, then the tweets should populate

### Bonuses Accomplished

* Links to tweet's owner

* Parses `@mentions`

* User creation, listing, update, and profile pages 

* User search

* User stats 

* Spec test cases