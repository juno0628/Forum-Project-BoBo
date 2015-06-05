require 'sinatra'
require 'sinatra/contrib'
require 'pry'
require 'pg'
require 'redcarpet'
require_relative 'server'

use Rack::MethodOverride

run Bobo::Server


