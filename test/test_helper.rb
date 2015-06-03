# -*- encoding: utf-8 -*-

require 'simplecov'
SimpleCov.start

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/spec'
require 'minitest/autorun'

require 'open_calais'
