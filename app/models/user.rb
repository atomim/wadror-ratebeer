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

  def password_does_not_consist_of_only_letters
    if (password =~ /\d/).nil?
      errors.add(:password, "password must not consist of only letters")
    end
  end
end
