require 'rest-client'
require 'pg'

module Bobo
	class Server < Sinatra::Base
		configure :development do
      $db = PG.connect dbname: "bobo", host: "localhost"
    end

    configure :production do
      require 'uri'
      uri = URI.parse ENV["DATABASE_URL"]
      $db = PG.connect dbname: uri.path[1..-1],
                         host: uri.host,
                         port: uri.port,
                         user: uri.user,
                     password: uri.password
    end

		$topic; 
		$location; 
		set :sessions, true
		enable :method_overide
		configure :development do 
		register Sinatra::Reloader
		end


		# user login
		def current_user
				session[:user_id]
		end

		# checking log in status
		def logged_in?
      !current_user.nil?
    end

    # chart page to see each user's contribution 
		get '/chart' do 
			@chart_data = $db.exec_params("SELECT users.user_id, count(distinct topics.id) AS number_of_topic, count(distinct comments.id) AS number_of_comment FROM topics INNER JOIN users ON topics.user_id = users.id LEFT JOIN comments ON comments.user_id = users.id group by users.user_id;").entries
			@label = @chart_data.map do |row|
				row['user_id']
			end
			@topic = @chart_data.map do |row|
				row['number_of_topic']
			end
			@comment = @chart_data.map do |row|
				row['number_of_comment']
			end
			erb :chart
		end

		get '/' do
			redirect '/topics'
		end

		get '/topics' do
			#retrieving user location info and parse to ruby
			user_id = session[:user_id]
			url = 'http://ipinfo.io/json'
			json_ipinfo = RestClient.get(url)
			data=JSON.parse(json_ipinfo)
			$location = "#{data['ip']} #{data['city']} #{data['region']} #{data['country']}"
			
			#showing comments from db 
			# show all topics
			# with links to all the comments for that topic
			@topics = $db.exec_params("select distinct topic_text, count(comments_text) AS counter, topics.id,vote, topics.location FROM topics LEFT JOIN comments ON topics.id = comments.topic_id GROUP BY topics.topic_text, topics.id, vote, topics.location order by vote desc;")
			erb :topics 	
		end

		post '/vote' do
			@id = params.keys.first.to_i
			if params.values.first == 'up' 
				vote = $db.exec_params("UPDATE topics SET vote = vote + 1 where id=$1;",[@id])
				redirect '/topics'
			elsif params.values.first == 'down'
				vote = $db.exec_params("UPDATE topics SET vote = vote - 1 where id = $1;", [@id])
				redirect '/topics'
			else 
				redirect '/login'
			end
		end


		post '/newtopic' do
			# adding user and topic content to the topics table, redirect to topics
			if session[:user_id]!= nil
				user = $db.exec_params("SELECT id from users where user_id = $1", [session[:user_id]]).first
				id = user['id'].to_i
			
				update = $db.exec_params("INSERT INTO topics (category, topic_text, user_id, location) VALUES ($1,$2,$3, $4);",[params[:category],params[:text],id, $location])		
				redirect '/topics'
			#if user is not logged in, then redirect to login page. 
			else
				redirect '/login' 
			end
		end

			# adding new topic 
		get '/newtopic' do
			erb :topic
		end
			# login page 
		get '/login' do
			erb :login
		end

		get '/topics/:id' do
			# show all the comments for a topic
			@id = params[:id]
			$topic = $db.exec_params("SELECT * from topics where id = $1",[@id]).first
			
			@comments = $db.exec_params("SELECT comments.*, users.user_id AS userid from comments LEFT JOIN users ON comments.user_id = users.id where topic_id = $1",[@id])
			erb :comments
		end


		# adding comment 
		get '/comment' do
		 erb :comment
		end

		# adding comment 
		post '/newcomment' do	
					user = session[:user_id]
					query = $db.exec_params("SELECT id from users where user_id = $1",[user]).first
			if session[:user_id]!=nil
				@user = query['id'].to_i
				id=$topic['id']
				$db.exec_params("INSERT INTO comments (topic_id, user_id, comments_text, location) VALUES ($1,$2,$3, $4);",[$topic['id'], @user, params['text'], $location])
				redirect "/topics/#{id}"
			else 
				erb :login
			end 
		end

		# login set up linked with login page
		post '/login' do
			user = $db.exec_params('SELECT * from users where user_id = $1 and password = $2', [params[:user_id],params[:password]]).first
			if user && user['password'] == params[:password]
			 	session[:user_id] = user['user_id']
			 	 redirect '/topics'
			else 
			 		@msg = "Incorrect Login ID or Password"
			 		erb :login
			end
			 	
		end

		get '/newuser' do
			erb :signup
		end

		post '/newuser' do
			$db.exec_params("INSERT INTO USERS (user_id, password, user_email, fullname) VALUES ($1,$2,$3,$4)",[params['user_id'], params['password'], params['user_email'], params['fullname']])
			redirect '/login'
		end

		delete '/logout' do
			session[:user_id] = nil
	    redirect '/topics'
	  end
	end	#Server
end	#Bobo
