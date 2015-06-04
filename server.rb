require 'sinatra'
require 'sinatra/contrib'
require 'pry'


module Bobo
	class Server < Sinatra::Base
		configure do 
		register Sinatra::Reloader
		enable :session
		end

	get '/' do
		
	end

	end	#Server
end	#Bobo
