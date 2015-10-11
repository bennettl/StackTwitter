require 'spec_helper'
require 'rails_helper'

feature 'User' do
    
    given(:user) { create(:user) } 

    scenario 'User sign in' do
        user
        visit root_path
        fill_in 'user_email',       with: user.email
        fill_in 'user_password',    with: user.password
        click_button 'Sign In'
        expect(page).to have_css('#tweet-box')
    end

    scenario 'User sign up' do
        visit new_user_path
        fill_in 'user_first_name',              with: Faker::Name.first_name
        fill_in 'user_last_name',               with: Faker::Name.last_name
        fill_in 'user_email',                   with: Faker::Internet.email
        fill_in 'user_password',                with: 'Testing123'
        fill_in 'user_password_confirmation',   with: 'Testing123'
        click_button "Let's go!"
        expect(page).to have_css('.alert-success')
    end

    
end