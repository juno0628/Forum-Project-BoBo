require_relative 'connections'

module Bobo
	class Server < Sinatra::Base
		$topic; 
		set :sessions, true
		enable :method_overide
		configure do 
		register Sinatra::Reloader
	end

	def current_user
			session[:user_id]
	end

	get '/' do
		redirect '/topics'
	end

	get '/topics' do
		user_id = session[:user_id]


		#showing comments from db 
		# show all topics
		# with links to all the comments for that topic
		@topics = $db.exec_params("select distinct topic_text, count(comments_text) AS counter, topic_id,vote FROM topics LEFT JOIN comments ON topics.id = comments.topic_id GROUP BY topic_text, topic_id, vote order by vote desc;;")

		binding. pry 
		erb :topics 	
	end

	post '/vote' do
		binding.pry
		@id = params.keys.first.to_i
		if params.values.first == 'up' 
		 vote = $db.exec_params("UPDATE topics SET vote = vote + 1 where id = $1;", [@id])
		 redirect '/topics'

		elsif params.values.first == 'down'
			vote = $db.exec_params("UPDATE topics SET vote = vote - 1 where id = $1;", [@id])
		 redirect '/topics'
		end
	end


	post '/newtopic' do
		if session[:user_id]!= nil
			
			user = $db.exec_params("SELECT id from users where user_id = $1", [session[:user_id]]).first
			id = user['id'].to_i
		
			update = $db.exec_params("INSERT INTO topics (category, topic_text, topic_image, user_id) VALUES ($1, $2, $3, $4)",[params[:category], params[:text], params[:image],id])
				binding.pry
		redirect '/topics'
		else
			redirect '/login' 
		end
	end

	get '/newtopic' do
		erb :topic
	end

	get '/login' do
		erb :login
	end

	get '/topics/:id' do
		# show all the comments for a topic
	
		@id = params[:id]
		$topic = $db.exec_params("SELECT * from topics where id = $1",[@id]).first
		
		@comments = $db.exec_params("SELECT * from comments where topic_id = $1",[@id])
		
		erb :comments
	end


	# adding comment 
	get '/comment' do
	 erb :comment
	end

	# adding comment 
	post '/newcomment' do
				user = session[:user_id]
				query = $db.exec_params('SELECT id from users where user_id = $1',[user]).first
				@user = query['id'].to_i
				id=$topic['id']
		if session[:user_id]!=nil
			$db.exec_params('INSERT INTO comments (topic_id, user_id, comments_text, comments_image) VALUES ($1,$2,$3,$4);',[$topic['id'], @user, params['text'], params['image']])
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




	end	#Server
end	#Bobo
