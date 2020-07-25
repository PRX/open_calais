# -*- encoding: utf-8 -*-

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start
end

require 'minitest/autorun'

require 'open_calais'
