require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'bundler'
Bundler.require

require './lib/weather_ferret'


