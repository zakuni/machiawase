#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestPlace < MiniTest::Test
  include Machiawase
  
  def test_address
    assert_equal "日本, 神奈川県横浜市中区真砂町１丁目１", Place.new(35.4437078, 139.6380256).address
  end

  def test_geocode
    assert_equal({"lat" => 35.4437078, "lon" => 139.6380256}, Place.geocode('横浜'))
  end

  def test_near_station
    assert_equal "関内駅", Place.new(35.4437978, 139.6380256).near_station
  end
end
