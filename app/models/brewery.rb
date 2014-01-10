class Brewery < ActiveRecord::Base
  include RatingAverage
  attr_accessible :name, :year

  has_many :beers
  has_many :ratings, :through => :beers

  validates :name, presence: true
  validates_numericality_of :year, {  :greater_than_or_equal_to => 1042,
                                      :only_integer => true }
  validate :year_must_not_be_in_the_future

  def year_must_not_be_in_the_future
    if Time.now.year < year
      errors.add(:year, "Year must not be in the future")
    end
  end

  def to_s
    "#{name}, #{year}"
  end
end
