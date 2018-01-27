#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestMachiawase < MiniTest::Test
  def test_where
    assert_kind_of Machiawase::Place, Machiawase.where("横浜", "東京")
    assert_equal "日本、〒146-0084 東京都大田区南久が原２丁目２０−１０", Machiawase.where("横浜", "東京").address
  end

  def test_parse_proxy
    assert_respond_to Machiawase, :parse_proxy

    return_with_nil = Machiawase.parse_proxy(nil)
    assert_kind_of OpenStruct, return_with_nil
    assert_respond_to return_with_nil, :user
    assert_respond_to return_with_nil, :pass

    assert_equal(OpenStruct.new({"server" => "http://host:port",
                                  "user" => "user",
                                  "pass" => "pass"}),
                 Machiawase.parse_proxy("user:pass@host:port"))

    assert_equal(OpenStruct.new({"server" => "http://host:port",
                                  "user"   => "",
                                  "pass"   => ""}),
                 Machiawase.parse_proxy("host:port"))

    assert_equal(OpenStruct.new({"server" => nil,
                                  "user"   => "",
                                  "pass"   => ""}),
                 Machiawase.parse_proxy(nil))
  end
end
