require 'spec_helper'

describe Beer do

  describe "should not be created" do
    it "without a name" do
      beer = Beer.create :style => "Moi"
      expect(beer.valid?).to be(false)
      expect(Beer.count).to eq(0)
    end
    it "without a style" do
      beer = Beer.create :name => "Moi"
      expect(beer.valid?).to be(false)
      expect(Beer.count).to eq(0)
    end
  end
end
