module Machiawase
  class Place
    attr_reader :address, :near_station
    attr_accessor :lat, :lon

    def initialize(lat, lon)
      @lat          = lat 
      @lon          = lon 
      @doc          = nil
      @address      = nil
      @near_station = nil
    end

    def lat=(val)
      @lat          = val
      @doc          = nil
      @address      = nil
      @near_station = nil
    end

    def lon=(val)
      @lon          = val
      @doc          = nil
      @address      = nil
      @near_station = nil
    end

    def self.geocode(address)
      address  = URI.encode(address)
      hash     = Hash.new
      baseUrl  = "http://maps.google.com/maps/api/geocode/json"
      reqUrl   = "#{baseUrl}?address=#{address}&sensor=false&language=ja"
      response = Net::HTTP.get_response(URI.parse(reqUrl))
      status   = JSON.parse(response.body)
      lat      = status['results'][0]['geometry']['location']['lat']
      lon      = status['results'][0]['geometry']['location']['lng']
      {"lat" => lat, "lon" => lon}
    end

    def address
      begin
        @doc ||= Nokogiri::HTML(open("http://geocode.didit.jp/reverse/?lat=#{@lat}&lon=#{@lon}"))
        @address ||= @doc.xpath('//address')[0].content
      rescue
        "Service Temporary Unavailable"
      end
    end

    def near_station
      begin
        @doc ||= Nokogiri::HTML(open("http://geocode.didit.jp/reverse/?lat=#{@lat}&lon=#{@lon}"))
        @near_station ||= @doc.xpath('//station1')[0].content
      rescue
        "Service Temporary Unavailable"
      end
    end

    def to_h
      {
        "latitude"     => @lat,
        "longtitude"   => @lon,
        "address"      => address,
        "near_station" => near_station
      }
    end

    def to_json
      JSON.pretty_generate(to_h)
    end
  end
end
