#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'machiawase/version'
require 'net/http'
require 'json'
require 'nokogiri'
require 'open-uri'

class Machiawase 
  class Coordinates
    attr :x, :y

    def initialize(x, y)
      @x = x 
      @y = y 
    end
  end

  def middle_of(*spots)
    @spots_coordinates = Hash.new
    @coordinates = Array.new
    
    spots.each do |spot|
      lat_lng = geocode(spot)
      @spots_coordinates.store(spot, lat_lng)
      @coordinates.push(Coordinates.new(lat_lng[0], lat_lng[1]))
    end

    lat_lon = centroid(*@coordinates)
    result = Hash.new
    @spots_coordinates.each do |spot, coordinates|
      result.store(spot, 
                   {"latitude" => coordinates[0],
                     "longtitude" => coordinates[1],
                     "address" => address(coordinates[0], coordinates[1])
                   })
    end
    result.store("result", 
                 {"latitude" => lat_lon[0],
                   "longtitude" => lat_lon[1],
                   "address" => address(lat_lon[0], lat_lon[1])
                 })
    JSON.pretty_generate(result)
  end

  def near_station(coordinates)
    reqUrl = "http://express.heartrails.com/api/json?method=getStations&x=#{coordinates.x}&y=#{coordinates.y}"
    response = Net::HTTP.get_response(URI.parse(reqUrl))
    status = JSON.parse(response.body)
  end

  private

  def geocode(address)
    address = URI.encode(address)
    hash = Hash.new
    baseUrl = "http://maps.google.com/maps/api/geocode/json"
    reqUrl = "#{baseUrl}?address=#{address}&sensor=false&language=ja"
    response = Net::HTTP.get_response(URI.parse(reqUrl))
    status = JSON.parse(response.body)
    lat = status['results'][0]['geometry']['location']['lat']
    lng = status['results'][0]['geometry']['location']['lng']
    [lat, lng]
  end

  def centroid(*coordinates)
    @x_sum = 0
    @y_sum = 0

    coordinates.each do |c|
      @x_sum += c.x
      @y_sum += c.y
    end

    [@x_sum/coordinates.length.to_f, @y_sum/coordinates.length.to_f]
  end

  def address(lat, lon)
    begin
      doc = Nokogiri::HTML(open("http://nishioka.sakura.ne.jp/google/ws.php?lat=#{lat}&lon=#{lon}&format=simple"))
      address = doc.xpath('//address')[0].content
    rescue
      address = "Service Temporary Unavailable"
    end
  end

end
