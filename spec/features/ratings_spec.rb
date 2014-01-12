require 'spec_helper'

describe "Rating" do
  include OwnTestHelper
  let!(:brewery) { FactoryGirl.create :brewery, :name => "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, :name => "iso 3", :brewery => brewery }
  let!(:beer2) { FactoryGirl.create :beer, :name => "Karhu", :brewery => brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user, :username => "Karhu" }

  before :each do
    sign_in 'Pekka', 'foobar1'
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select(beer1.to_s, :from => 'rating[beer_id]')
    fill_in('rating[score]', :with => '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "are all listed on the ratings page" do
    (1..10).to_a.each do |a|
      create_beer_with_rating a,user,{:name=>"olut#{a}"}
    end
    visit ratings_path
    Rating.all.each do |rating|
      expect(page).to have_content rating.score
      expect(page).to have_content rating.beer.name
    end
  end

  it "are listed on user's page" do
    (1..10).to_a.each do |a|
      create_beer_with_rating a,user,{:name=>"olut#{a}"}
    end
    visit user_path(user)
    (1..10).to_a.each do |a|
      expect(page).to have_content "olut#{a}"
    end
  end

  it "deleting removes rating from database" do
    create_beer_with_rating 10,user

    visit root_path
    click_link "Pekka"

    expect{
      click_link "delete"
    }.to change{Rating.count}.by(-1)
  end
end
