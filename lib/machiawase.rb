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
end
