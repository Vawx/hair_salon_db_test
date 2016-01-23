require 'capybara/rspec'
require './app'
Capybara.app = Sinatra::Application
set( :show_expceptions, false )

feature 'adding a new client' do
  scenario 'allows addition of new client' do
    visit '/'
    fill_in 'client_new_name', with: "kyle"
    fill_in 'stylist_name', with: "edward"
    click_button 'Add Match'
    expect(page).to have_content('kyle')
  end
end

feature 'adding a new stylist' do
  scenario 'allows addition of new stylist' do
    visit '/'
    fill_in 'client_new_name', with: "kyle"
    fill_in 'stylist_name', with: "edward"
    click_button 'Add Match'
    expect(page).to have_content('edward')
  end
end
