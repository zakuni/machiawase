#!/usr/bin/env rake
require "bundler/gem_tasks"

task :default => :test

task :test do
  require 'guard'
  Guard.setup :guardfile => 'Guardfile'
  Guard.run_all 
end
