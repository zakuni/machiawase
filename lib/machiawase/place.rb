# -*- coding: utf-8 -*-
module Machiawase

  # @!attribute [r] address
  #   @return [String] the address.
  # @!attribute [r] near_station
  #   @return [String] the nearest station.  
  # @!attribute [r] google_map_url
  #   @return [String] the url of Google Map.
  # @!attribute [rw] lat
  #   @return the latitude.
  # @!attribute [rw] lon
  #   @return the longitude.
  class Place 
    include Geocoder

    attr_reader :address, :near_station, :google_map_url
    attr_accessor :lat, :lon

    def initialize(lat, lon)
      @lat            = lat 
      @lon            = lon 
      @address        = nil
      @near_station   = nil
      @google_map_url = "http://maps.google.co.jp/maps?q=#{@lat},#{@lon}&ll=#{@lat},#{@lon}&z=14&t=m&brcurrent=3,0x0:0x0,1"
      @proxy          = Machiawase.parse_proxy(ENV["http_proxy"])
      Place.configure      
    end

    def lat=(val)
      @lat          = val
      @address      = nil
      @near_station = nil
    end

    def lon=(val)
      @lon          = val
      @address      = nil
      @near_station = nil
    end

    # @return [Hash] geocode of given address.
    def self.geocode(address)
      Place.configure
      lat, lon = Geocoder.coordinates(address)
      {"lat" => lat, "lon" => lon}
    rescue => exc
      p exc
    end

    def self.configure
      Geocoder.configure(
        :language => :ja,
        :http_proxy => ENV["http_proxy"]
      )
    end

    def address
      Place.configure
      @address ||= Geocoder.address([@lat, @lon])
    rescue => exc
      p exc
    end

    def near_station
      @near_station ||= Nokogiri::HTML(
        open("http://geocode.didit.jp/reverse/?lat=#{@lat}&lon=#{@lon}",
        :proxy_http_basic_authentication => [@proxy.server, @proxy.user, @proxy.pass]
      )).xpath('//station1')[0].content
    rescue => exc
      p exc
    end
    
    # @return [Hash] attributes with Hash format.
    def to_h
      {
        "latitude"     => @lat,
        "longitude"    => @lon,
        "address"      => address,
        "near_station" => near_station,
        "google_map"   => @google_map_url
      }
    end

    # @return [JSON] attributes with JSON format.
    def to_json
      JSON.pretty_generate(to_h)
    end

    def to_msgpack
      to_h.to_msgpack
    end
  end
end
