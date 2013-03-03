#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'spec_helper'

describe Machiawase do
  describe 'where' do
    describe '横浜, 東京' do
      it 'should be Place' do
        Machiawase.where("横浜", "東京").class.must_equal(Machiawase::Place)
      end
    end
  end
end

describe Machiawase::Rendezvous do
  before do
    @machiawase = Machiawase::Rendezvous.new
  end

  describe ":centroid" do
    describe '(0, 0), (1, 1)' do
      it 'should be (0.5, 0.5)' do
        place_a = Machiawase::Place.new(0, 0)
        place_b = Machiawase::Place.new(1, 1)
        @machiawase.send(:centroid, *[place_a, place_b]).must_equal([0.5, 0.5])
      end
    end
    describe '(0, 0), (1, 1), (2, 2)' do
      it 'should be (1, 1)' do
        place_a = Machiawase::Place.new(0, 0)
        place_b = Machiawase::Place.new(1, 1)
        place_c = Machiawase::Place.new(2, 2)
        @machiawase.send(:centroid, *[place_a, place_b, place_c]).must_equal([1, 1])
      end
    end
    describe '(0, 0), (2, 0), (2, 2), (0, 2)' do
      it 'should be (1, 1)' do
        place_a = Machiawase::Place.new(0, 0)
        place_b = Machiawase::Place.new(2, 0)
        place_c = Machiawase::Place.new(2, 2)
        place_d = Machiawase::Place.new(0, 2)
        @machiawase.send(:centroid, *[place_a, place_b, place_c, place_d]).must_equal([1, 1])
      end
    end
  end

  describe ':middle_of' do
    describe '横浜, 東京' do
      it 'should be Place' do
        g1 = Machiawase::Place.geocode("横浜")
        p1 = Machiawase::Place.new(g1['lat'], g1['lon'])
        
        g2 = Machiawase::Place.geocode("東京")
        p2 = Machiawase::Place.new(g2['lat'], g2['lon'])
        
        @machiawase.send(:middle_of, p1, p2).class.must_equal(Machiawase::Place)
      end
    end
  end
end
