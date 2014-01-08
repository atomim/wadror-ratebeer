class Beer < ActiveRecord::Base
  attr_accessible :brewery_id, :name, :style

  belongs_to :brewery
  has_many :ratings, :dependent => :destroy

  def average_rating
    ratings.inject(0.0) {|result,rating| result + rating.score } / ratings.count
  end
  def to_s
    "#{name}, #{brewery.name}"
  end
end
