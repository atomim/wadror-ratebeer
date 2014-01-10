class User < ActiveRecord::Base
  include RatingAverage
  attr_accessible :username, :password, :password_confirmation
  has_secure_password

  has_many :ratings, :dependent => :destroy
  has_many :beers, :through => :ratings

  validates_uniqueness_of :username
  validates_length_of :password, :minimum => 4
  validates :username, length: { minimum: 3, maximum: 15}
  validate :password_does_not_consist_of_only_letters

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by{ |r| r.score }.last.beer
  end

  def group_ratings_by_style(ratings)
    ratings.group_by{|r| r.beer.style }
  end

  def average_for_ratings_array(ratings_array)
    #puts ratings_array
    ratings_array.drop(1).inject(0) {|sum,rating| sum+rating.score} / ratings.count
  end

  def favorite_style
    return nil if ratings.empty?
    group_ratings_by_style(ratings)
      .map{|style, ratings| [style,average_for_ratings_array(ratings)]}
        .max{|average| average[1]}[0]
  end

  def password_does_not_consist_of_only_letters
    if (password =~ /\d/).nil?
      errors.add(:password, "password must not consist of only letters")
    end
  end
end
