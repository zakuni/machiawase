#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'machiawase/version'
require 'net/http'
require 'json'
require 'nokogiri'
require 'open-uri'

class Machiawase 
  attr :lat, :lon, :address, :near_station

  def initialize(*places)
    @places = places
  end

  class Place
    attr :lat, :lon

    def initialize(lat, lon)
      @lat = lat 
      @lon = lon 
      @doc = nil
    end

    def self.geocode(address)
      address = URI.encode(address)
      hash = Hash.new
      baseUrl = "http://maps.google.com/maps/api/geocode/json"
      reqUrl = "#{baseUrl}?address=#{address}&sensor=false&language=ja"
      response = Net::HTTP.get_response(URI.parse(reqUrl))
      status = JSON.parse(response.body)
      lat = status['results'][0]['geometry']['location']['lat']
      lon = status['results'][0]['geometry']['location']['lng']
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

    def to_json
      JSON.pretty_generate({
                             "latitude" => @lat,
                             "longtitude" => @lon,
                             "address" => address,
                             "near_station" => near_station
                           })
    end
  end

  def middle_of(*spots)
    places = Array.new
    
    spots.each do |spot|
      coordinates = Place.geocode(spot)
      places.push(Place.new(coordinates["lat"], coordinates["lon"]))
    end

    c = centroid(*places)
    return Place.new(c[0], c[1])
  end

  private

  def centroid(*coordinates)
    @x_sum = 0
    @y_sum = 0

    coordinates.each do |c|
      @x_sum += c.lat
      @y_sum += c.lon
    end

    [@x_sum/coordinates.length.to_f, @y_sum/coordinates.length.to_f]
  end

end
