require 'spec_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    BeermappingAPI.stub(:places_in).with("kumpula").and_return( [  Place.new(:name => "Oljenkorsi",:id=>1) ] )

    visit places_path
    fill_in('city', :with => 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end
  it "if many are returned by the API, it is shown at the page" do
    BeermappingAPI.stub(:places_in).with("kumpula").and_return( [  Place.new(:name => "Oljenkorsi",:id=>1),
                                                                   Place.new(:name => "Parmesaani",:id=>1) ] )

    visit places_path
    fill_in('city', :with => 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Parmesaani"
  end
  it "if none returned by the API, page is shown correctly" do
    BeermappingAPI.stub(:places_in).with("kumpulo").and_return( [] )

    visit places_path
    fill_in('city', :with => 'kumpulo')
    click_button "Search"

    expect(page).to have_content "No locations in kumpulo"
  end
end
