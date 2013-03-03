#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'spec_helper'

describe Machiawase::Place do
  describe ':address' do
    describe '35.4437078, 139.6380256' do
      it 'should be 神奈川県横浜市中区真砂町1丁目9' do
        Machiawase::Place.new(35.4437078, 139.6380256).address.must_equal("神奈川県横浜市中区真砂町1丁目9")
      end
    end
  end

  describe 'geocode' do
    describe '横浜' do
      it 'should be {lat => 35.4437978, lon => 139.6380256}' do
        Machiawase::Place.geocode('横浜').must_equal({"lat" => 35.4437078, "lon" => 139.6380256})
      end
    end
  end

  describe 'near_station' do
    describe '横浜' do
      it 'should be 関内駅' do
        Machiawase::Place.new(35.4437978, 139.6380256).near_station.must_equal("関内駅")
      end
    end
  end
end

