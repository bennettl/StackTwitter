require 'spec_helper'
require 'rails_helper'

# save_and_open_page

feature 'Static Pages' do

    given(:user) { create(:user) } 

    scenario 'Non-signed in user visiting root page' do
        user
        visit root_path
        expect(page).to have_css('#signInBox')
    end

    scenario 'Signed in user visiting root page' do
        user
        login_as(user, :scope => :user)
        visit root_path
        expect(page).to have_css('#tweet-box')
    end

    scenario 'No tweets by default' do
        user
        login_as(user, :scope => :user)
        visit root_path
        expect(page).to have_content('Currently there are no tweets')
    end

    scenario 'Tweets exist with handle', js: true do
        user
        login_as(user, :scope => :user)
        visit root_path
        fill_in 'twitter-handle', with: 'playstation'
        click_button "Submit"
        sleep(3)
        expect(page.all(".tweet-container").count).to be > 2
    end

    
end