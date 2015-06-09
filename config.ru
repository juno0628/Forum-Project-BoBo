require 'sinatra'
require 'json'
require 'pg'
require 'redcarpet'
require_relative 'server'

use Rack::MethodOverride

run Bobo::Server


