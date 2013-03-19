#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module Machiawase

  class Rendezvous
    # @!attribute [r] place
    #   @return [Place] the place to rendezvous.
    # @!attribute [r] places
    #   @return [Array<Place>] the array of given places.
    #   @see Place

    attr_reader :place, :places, :lat, :lon, :address, :near_station
    
    # @param places [Array<Place>] the array of places. 
    def initialize(*places)
      @place  = nil
      @places = places
    end

    def place
      @place ||= middle_of(*@places)
    end

    def lat
      @place ||= middle_of(*@places)
      @place.lat
    end

    def lon
      @place ||= middle_of(*@places)
      @place.lon
    end

    def address
      @place ||= middle_of(*@places)
      @place.address
    end

    def near_station
      @place ||= middle_of(*@places)
      @place.near_station
    end

    # @return [Hash] the attributes with Hash format.
    def to_h
      h = Hash.new
      @places.each_with_index do |place, i|
        h.store("place#{i}", place.to_h)        
      end

      @place ||= middle_of(*@places)
      h.store("machiawase", @place.to_h)
    end

    # @return [JSON] the attributes with JSON format.
    def to_json
      JSON.pretty_generate(to_h)
    end

    private

    def middle_of(*places)
      c = centroid(*places)
      @place = Place.new(c[0], c[1])
    end

    def centroid(*places)
      x_sum = 0
      y_sum = 0

      places.each do |p|
        x_sum += p.lat
        y_sum += p.lon
      end

      [x_sum/places.length.to_f, y_sum/places.length.to_f]
    end
  end
end
