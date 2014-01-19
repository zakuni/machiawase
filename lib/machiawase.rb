#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'net/http'
require 'json'
require 'geocoder'
require 'msgpack'
require 'nokogiri'
require 'open-uri'
require 'ostruct'
require 'machiawase/place'
require 'machiawase/rendezvous'
require 'machiawase/version'

# @author {https://github.com/zakuni zakuni}
module Machiawase

  # @param argv [Array<Place>] the array of places.
  # @return [Place] the place to rendezvous.
  def self.where(*addresses)
    places = Array.new
    addresses.each do |address|
      g = Place.geocode(address)
      places << Place.new(g['lat'], g['lon'])
    end
    m = Rendezvous.new(*places)
    m.place
  end
end
