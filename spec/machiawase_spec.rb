#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'machiawase'

describe Machiawase do
  before do
    @machiawase = Machiawase.new
  end

  describe ":geocode" do
    context '横浜' do
      it 'should be 35.4437978, 139.6380256' do
        @machiawase.send(:geocode, "横浜").should eq([35.4437078, 139.6380256])
      end
    end
  end

  describe ":centroid" do
    context '(0, 0), (1, 1)' do
      it 'should be (0.5, 0.5)' do
        coordinates_a = Machiawase::Coordinates.new(0, 0)
        coordinates_b = Machiawase::Coordinates.new(1, 1)
        @machiawase.send(:centroid, *[coordinates_a, coordinates_b]).should eq([0.5, 0.5])
      end
    end
    context '(0, 0), (1, 1), (2, 2)' do
      it 'should be (1, 1)' do
        coordinates_a = Machiawase::Coordinates.new(0, 0)
        coordinates_b = Machiawase::Coordinates.new(1, 1)
        coordinates_c = Machiawase::Coordinates.new(2, 2)
        @machiawase.send(:centroid, *[coordinates_a, coordinates_b, coordinates_c]).should eq([1, 1])
      end
    end
    context '(0, 0), (2, 0), (2, 2), (0, 2)' do
      it 'should be (1, 1)' do
        coordinates_a = Machiawase::Coordinates.new(0, 0)
        coordinates_b = Machiawase::Coordinates.new(2, 0)
        coordinates_c = Machiawase::Coordinates.new(2, 2)
        coordinates_d = Machiawase::Coordinates.new(0, 2)
        @machiawase.send(:centroid, *[coordinates_a, coordinates_b, coordinates_c, coordinates_d]).should eq([1, 1])
      end
    end
  end

  describe ':place_name' do
    context '35.4437078, 139.6380256' do
      it 'should be 神奈川県横浜市中区真砂町一丁目1' do
        @machiawase.send(:place_name, 35.4437078, 139.6380256).should eq ("神奈川県横浜市中区真砂町一丁目1")
      end
    end
  end

  describe 'middle_of' do
    context '横浜, 東京' do
      it 'should be middle' do
        @machiawase.middle_of("横浜", "東京")
      end
    end
  end
end
