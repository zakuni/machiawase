#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'test_helper'

class TestRendezvous < MiniTest::Unit::TestCase
  include Machiawase

  def setup
    @rendezvous = Rendezvous.new
  end

  def test_centroid
    place_a = Place.new(0, 0)
    place_b = Place.new(1, 1)
    assert_equal [0.5, 0.5], @rendezvous.send(:centroid, *[place_a, place_b])

    place_a = Place.new(0, 0)
    place_b = Place.new(1, 1)
    place_c = Machiawase::Place.new(2, 2)
    assert_equal [1, 1], @rendezvous.send(:centroid, *[place_a, place_b, place_c])

    place_a = Place.new(0, 0)
    place_b = Place.new(2, 0)
    place_c = Place.new(2, 2)
    place_d = Place.new(0, 2)
    assert_equal [1, 1], @rendezvous.send(:centroid, *[place_a, place_b, place_c, place_d])
  end

  def test_middle_of
    g1 = Place.geocode("横浜")
    p1 = Place.new(g1['lat'], g1['lon'])
        
    g2 = Place.geocode("東京")
    p2 = Place.new(g2['lat'], g2['lon'])
    
    assert_kind_of Place, @rendezvous.send(:middle_of, p1, p2)
  end
end
