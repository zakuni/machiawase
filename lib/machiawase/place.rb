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
      address  = URI.encode(address)
      baseUrl  = "http://maps.google.com/maps/api/geocode/json"
      reqUrl   = "#{baseUrl}?address=#{address}&sensor=false&language=ja"
      proxy    = parse_proxy(ENV["http_proxy"])
      response = Net::HTTP::Proxy(proxy['host'], proxy['port'], proxy['user'], proxy['pass']).get_response(URI.parse(reqUrl))
      status   = JSON.parse(response.body)
      lat      = status['results'][0]['geometry']['location']['lat']
      lon      = status['results'][0]['geometry']['location']['lng']
      {"lat" => lat, "lon" => lon}
    end

    def self.parse_proxy(proxy)
      # http://user:pass@host:port のように書かれていることを想定
      # パスワードに@とか入ってる場合があるので一番後ろの@でだけsplitする
      rserver, raccount = (proxy || '').sub(/http:\/\//, '').reverse.split("@", 2)
      server  = rserver.nil? ? "" : rserver.reverse
      host, port = server.split(":")
      account = raccount.nil? ? "" : raccount.reverse.split(":")
      user, pass = account
      
      # serverはNokogiri(open-uri)で使う。host, portはNet::HTTPで使う。
      {
        "server" => server.empty? ? nil : "http://#{server}",
        "host"   => host,
        "port"   => port,
        "user"   => user.nil? ? "" : user,
        "pass"   => pass.nil? ? "" : pass
      }
    end

    def address
      begin
        @doc ||= Nokogiri::HTML(open("http://geocode.didit.jp/reverse/?lat=#{@lat}&lon=#{@lon}", :proxy_http_basic_authentication => [@proxy['server'], @proxy['user'], @proxy['pass']]))
        @address ||= @doc.xpath('//address')[0].content
      rescue
        "Service Temporary Unavailable"
      end
    end

    def near_station
      begin
        @doc ||= Nokogiri::HTML(open("http://geocode.didit.jp/reverse/?lat=#{@lat}&lon=#{@lon}", :proxy => ENV['http_proxy']))
        @near_station ||= @doc.xpath('//station1')[0].content
      rescue
        "Service Temporary Unavailable"
      end
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
  end
end
