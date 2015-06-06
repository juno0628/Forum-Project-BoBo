require 'sinatra'
require 'sinatra/contrib'
require 'json'
require 'pry'
require 'pg'
require 'redcarpet'
require_relative 'server'

use Rack::MethodOverride

run Bobo::Server


