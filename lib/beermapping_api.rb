class BeermappingAPI
  def self.places_in city
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{city.gsub(' ', '%20')}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    return places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.place id
    url = "http://beermapping.com/webservice/locquery/#{key}/#{id}"
    response = HTTParty.get url
    place = response.parsed_response["bmp_locations"]["location"]

    return Place.new(place)
  end

  def self.score id
    url = "http://beermapping.com/webservice/locscore/#{key}/#{id}"
    response = HTTParty.get url
    score = response.parsed_response["bmp_locations"]["location"]

    return score
  end



  def self.key
    "5d83fc832636f99b879e4d7a6cd7c9b9"
  end
end
