#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'spec_helper'

describe Machiawase::Place do
  describe ':address' do
    it 'returns 神奈川県横浜市中区真砂町1丁目9 with "35.4437078, 139.6380256"' do
      Machiawase::Place.new(35.4437078, 139.6380256).address.must_equal("神奈川県横浜市中区真砂町1丁目9")
    end
  end

  describe 'geocode' do
    it 'returns {lat => 35.4437978, lon => 139.6380256} with 横浜' do
      Machiawase::Place.geocode('横浜').must_equal({"lat" => 35.4437078, "lon" => 139.6380256})
    end
  end

  describe 'near_station' do
    it 'returns 関内駅 with 横浜' do
      Machiawase::Place.new(35.4437978, 139.6380256).near_station.must_equal("関内駅")
    end
  end

  describe "parse_proxy" do
    it 'responds' do
      Machiawase::Place.must_respond_to("parse_proxy")
    end
    
    it 'returns Hash' do
      Machiawase::Place.parse_proxy(nil).must_be_kind_of(Hash)
    end

    it 'includes "host"' do
      Machiawase::Place.parse_proxy(nil).must_include("host")
    end

    it 'includes "port"' do
      Machiawase::Place.parse_proxy(nil).must_include("port")
    end

    it 'includes "user"' do
      Machiawase::Place.parse_proxy(nil).must_include("user")
    end

    it 'includes "pass"' do
      Machiawase::Place.parse_proxy(nil).must_include("pass")
    end

    it 'returns correct hash with "user:pass@host:port"' do
      Machiawase::Place.parse_proxy(
                                    "user:pass@host:port"
                                    ).must_equal({
                                                   "server" => "http://host:port",
                                                   "host"   => "host",
                                                   "port"   => "port",
                                                   "user"   => "user",
                                                   "pass"   => "pass"
                                                 })
    end

    it 'returns correct hash with "host:port"' do
      Machiawase::Place.parse_proxy(
                                    "host:port"
                                    ).must_equal({
                                                   "server" => "http://host:port",

                                                   "host"   => "host",
                                                   "port"   => "port",
                                                   "user"   => "",
                                                   "pass"   => ""
                                                 })
    end

    it 'returns correct hash with nil' do
      Machiawase::Place.parse_proxy(nil).must_equal(
                                                    {
                                                      "server" => nil,
                                                      "host"   => nil,
                                                      "port"   => nil,
                                                      "user"   => "",
                                                      "pass"   => ""
                                                    })
    end
  end
end

