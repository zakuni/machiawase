#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'machiawase'


describe Machiawase::Place do
  describe ':address' do
    context '35.4437078, 139.6380256' do
      it 'should be 神奈川県横浜市中区真砂町1丁目9' do
        Machiawase::Place.new(35.4437078, 139.6380256).address.should eq("神奈川県横浜市中区真砂町1丁目9")
      end
    end
  end

  describe 'geocode' do
    context '横浜' do
      it 'should be {lat => 35.4437978, lon => 139.6380256}' do
        Machiawase::Place.geocode('横浜').should eq ({"lat" => 35.4437078, "lon" => 139.6380256})
      end
    end
  end

  describe 'near_station' do
    context '横浜' do
      it 'should be 関内駅' do
        Machiawase::Place.new(35.4437978, 139.6380256).near_station.should eq ("関内駅")
      end
    end
  end
end

describe Machiawase do
  before do
    @machiawase = Machiawase.new
  end

  describe 'middle_of' do
    context '横浜, 東京' do
      it 'should be Place' do
        m = @machiawase.middle_of("横浜", "東京")
        @machiawase.middle_of("横浜", "東京").class.should eq(Machiawase::Place)
      end
    end
  end

  describe ":centroid" do
    context '(0, 0), (1, 1)' do
      it 'should be (0.5, 0.5)' do
        place_a = Machiawase::Place.new(0, 0)
        place_b = Machiawase::Place.new(1, 1)
        @machiawase.send(:centroid, *[place_a, place_b]).should eq([0.5, 0.5])
      end
    end
    context '(0, 0), (1, 1), (2, 2)' do
      it 'should be (1, 1)' do
        place_a = Machiawase::Place.new(0, 0)
        place_b = Machiawase::Place.new(1, 1)
        place_c = Machiawase::Place.new(2, 2)
        @machiawase.send(:centroid, *[place_a, place_b, place_c]).should eq([1, 1])
      end
    end
    context '(0, 0), (2, 0), (2, 2), (0, 2)' do
      it 'should be (1, 1)' do
        place_a = Machiawase::Place.new(0, 0)
        place_b = Machiawase::Place.new(2, 0)
        place_c = Machiawase::Place.new(2, 2)
        place_d = Machiawase::Place.new(0, 2)
        @machiawase.send(:centroid, *[place_a, place_b, place_c, place_d]).should eq([1, 1])
      end
    end
  end
end
