require 'spec_helper'

describe "User" do
  include OwnTestHelper
  before :each do
    @user = FactoryGirl.create :user unless @user
  end
  #let!(:user) { FactoryGirl.create :user }

  describe "who has signed up" do
    it "can sign in with right credentials" do
      sign_in 'Pekka', 'foobar1'
      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end
  end

  it "is redirected back to sign in form if wrong credentials given" do
    sign_in 'Pekka', 'foobar2'
    expect(current_path).to eq(signin_path)
    expect(page).to have_content 'username and password do not match'
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', :with => 'Brian')
    fill_in('user_password', :with => 'secret55')
    fill_in('user_password_confirmation', :with => 'secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "is able to add a beer" do
    sign_in 'Pekka', 'foobar1'
    visit new_beer_path
    fill_in('beer_name', :with => 'Juoma')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "has favourite beer style and brewery shown" do
    sign_in 'Pekka', 'foobar1'
    create_beer_with_rating 10,@user,{:style=>"hiaa",:brewery=>FactoryGirl.create(:brewery)}
    visit user_path(@user)


    expect(page).to have_content "favorite style: hiaa"
    expect(page).to have_content "favorite brewery: anonymous"
  end

end
