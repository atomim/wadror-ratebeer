require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new :username => "Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a proper password" do
    user = User.create :username => "Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end
  describe "shoud not be saved with a password" do
    it "consisting of only letters" do
      user = User.create :username => "Pekka", :password => "secret", :password_confirmation => "secret"

      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end

    it "too short" do
      user = User.create :username => "Pekka", :password => "se", :password_confirmation => "se"

      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end
  end


  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating 10, user

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings :scores=>[10, 20, 15, 7, 9], :user=> user
      best = create_beer_with_rating 25, user

      expect(user.favorite_beer).to eq(best)
    end

  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }
    it "has method for determining one" do
      user.should respond_to :favorite_style
    end
    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end
    it "is of the only rated if only one rating" do
      beer = create_beer_with_rating 10, user

      expect(user.favorite_style).to eq(beer.style)
    end
    it "is of one with the highest average rating" do
      create_beers_with_ratings :scores=>[10, 20, 15, 7, 9], :user=> user,:overrides=>{:style=>"moi"}
      best = create_beers_with_ratings :scores=>[15, 20], :user=> user, :overrides=>{:style=>"muuh"}

      expect(user.favorite_style).to eq("muuh")
    end
  end

    describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }
    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end
    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end
    it "is of the only rated if only one rating" do
      beer = create_beer_with_rating 10, user

      expect(user.favorite_brewery).to eq(beer.brewery)
    end
    it "is of one with the highest average rating" do
      brewery1 = FactoryGirl.create(:brewery, {:name => "an1"})
      brewery2 = FactoryGirl.create(:brewery, {:name => "an2"})
      create_beers_with_ratings :scores=>[10, 20, 15, 7, 9], :user=> user,:overrides=>{:brewery=>brewery1}
      create_beers_with_ratings :scores=>[11, 21, 16, 17, 29], :user=> user,:overrides=>{:brewery=>brewery2}

      expect(user.favorite_brewery).to eq(brewery2)
    end
  end
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
