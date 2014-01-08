class Brewery < ActiveRecord::Base
  attr_accessible :name, :year

  has_many :beers

  def to_s
    "#{name}, #{year}"
  end
end
