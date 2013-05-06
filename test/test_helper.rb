require 'rubygems'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/pride'

$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'machiawase'

MiniTest::Reporters.use! [MiniTest::Reporters::DefaultReporter.new, MiniTest::Reporters::GuardReporter.new]
