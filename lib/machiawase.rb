#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'net/http'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'machiawase/place'
require 'machiawase/version'

class Machiawase 
  attr :lat, :lon, :address, :near_station

  def initialize(*places)
    @places = places
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
