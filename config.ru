require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'] || 'development')

require_relative 'server'
use Rack::MethodOverride

run Bobo::Server


