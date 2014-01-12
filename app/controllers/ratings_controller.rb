class RatingsController < ApplicationController
  before_filter :ensure_that_signed_in, :except => [:index]
  def index
  	@ratings = Rating.all
  end

  def new
  	@rating = Rating.new
    @beers = Beer.all
  end

def create
  @rating = Rating.new params[:rating]

  if @rating.save
    current_user.ratings << @rating
    redirect_to user_path current_user
  else
    @beers = Beer.all
    render :new
  end
end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end
