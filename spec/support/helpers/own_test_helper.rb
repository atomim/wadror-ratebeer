module OwnTestHelper
  def sign_in(username, password)
    visit signin_path
    fill_in('username', :with => username)
    fill_in('password', :with => password)
    click_button('Log in')
  end

  def create_beers_with_ratings(params={})
    params[:scores].each do |score|
      create_beer_with_rating score, params[:user],params[:overrides]
    end
  end

  def create_beer_with_rating(score, user, overrides={} )
    beer = FactoryGirl.create(:beer, overrides)
    FactoryGirl.create(:rating, :score => score,  :beer => beer, :user => user)
    beer
  end
end
