#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'machiawase/version'
require 'net/http'
require 'json'
require 'hpricot'
require 'open-uri'

class Machiawase 
  def middle_of(*spots)
    @coordinates = Array.new
    
    spots.each do |spot|
      lat_lng = geocode(spot)
      @coordinates.push(Coordinates.new(lat_lng[0], lat_lng[1]))
    end

    lat_lon = centroid(*@coordinates)
    place_name(lat_lon[0], lat_lon[1])
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

  def place_name(lat, lon)
    doc = Hpricot(open("http://nishioka.sakura.ne.jp/google/ws.php?lat=#{lat}&lon=#{lon}&format=simple"))
    address = doc.at(:address).inner_text
  end

end

class Coordinates
  attr :x, :y

  def initialize(x, y)
    @x = x 
    @y = y 
  end
end

if __FILE__ == $0
  machiawase = Machiawase.new
  puts machiawase.middle_of(ARGV[0], ARGV[1])
end
