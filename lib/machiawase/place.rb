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
      @doc            = nil
      @address        = nil
      @near_station   = nil
      @google_map_url = "http://maps.google.co.jp/maps?q=#{@lat},#{@lon}&ll=#{@lat},#{@lon}&z=14&t=m&brcurrent=3,0x0:0x0,1"
      @proxy          = Place.parse_proxy(ENV["http_proxy"])
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

    # @return [Hash] geocode of given address.
    def self.geocode(address)
      lat, lon = Geocoder.coordinates(address)
      {"lat" => lat, "lon" => lon}
    rescue => exc
      p exc
    end

    def self.parse_proxy(proxy)
      # http://user:pass@host:port のように書かれていることを想定
      # パスワードに@とか入ってる場合があるので一番後ろの@でだけsplitする
      rserver, raccount = (proxy || '').sub(/http:\/\//, '').reverse.split("@", 2)
      server  = rserver.nil? ? "" : rserver.reverse
      host, port = server.split(":")
      account = raccount.nil? ? "" : raccount.reverse.split(":")
      user, pass = account
      
      proxy = OpenStruct.new({      
                               "server" => server.empty? ? nil : "http://#{server}",
                               "user"   => user.nil? ? "" : user,
                               "pass"   => pass.nil? ? "" : pass
                             })
    end

    def address
      @address ||= Geocoder.address([@lat, @lon])
    rescue => exc
      p exc
    end

    def near_station
      @doc ||= Nokogiri::HTML(open("http://geocode.didit.jp/reverse/?lat=#{@lat}&lon=#{@lon}", :proxy_http_basic_authentication => [@proxy.server, @proxy.user, @proxy.pass]))
      @near_station ||= @doc.xpath('//station1')[0].content
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
