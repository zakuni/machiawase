#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestPlace < MiniTest::Test
  include Machiawase
  
  def test_address
    assert_equal "神奈川県横浜市中区真砂町1丁目9", Place.new(35.4437078, 139.6380256).address
  end

  def test_geocode
    assert_equal({"lat" => 35.4437078, "lon" => 139.6380256}, Place.geocode('横浜'))
  end

  def test_near_station
    assert_equal "関内駅", Place.new(35.4437978, 139.6380256).near_station
  end

  def test_parse_proxy
    assert_respond_to Place, :parse_proxy

    return_with_nil = Place.parse_proxy(nil)
    assert_kind_of OpenStruct, return_with_nil
    assert_respond_to return_with_nil, :user
    assert_respond_to return_with_nil, :pass

    assert_equal(OpenStruct.new({"server" => "http://host:port",
                                  "user" => "user",
                                  "pass" => "pass"}),
                 Place.parse_proxy("user:pass@host:port"))
    
    assert_equal(OpenStruct.new({"server" => "http://host:port",
                                  "user"   => "",
                                  "pass"   => ""}),
                 Place.parse_proxy("host:port"))

    assert_equal(OpenStruct.new({"server" => nil,
                                  "user"   => "",
                                  "pass"   => ""}),
                 Place.parse_proxy(nil))
  end
end
