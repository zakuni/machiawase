#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestMachiawase < MiniTest::Unit::TestCase
  def test_where
    assert_kind_of Machiawase::Place, Machiawase.where("横浜", "東京")
  end
end
