class Rating < ActiveRecord::Base
  attr_accessible :beer_id, :score
  
  belongs_to :beer

  def to_s
  	"#{beer.name} #{score}"
  end
end
