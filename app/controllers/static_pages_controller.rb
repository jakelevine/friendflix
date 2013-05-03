class StaticPagesController < ApplicationController
  	def home
  	end
	
	def upload
		user_data = Hash.new
		@movies_json = Hash.new
		final = Hash.new
		movies = params[:movies]
		name = params[:name].gsub(/\s+/, "").downcase

		user_data["name"] = name
		
		File.open(Rails.root.join('public', 'uploads', movies.original_filename), 'wb') do |file|			
			@movies_json = movies.read			
		end
		
		user_data["movies"] = @movies_json
	
		begin 
			User.create_new_user(user_data)
			session[:name] = name
		  	redirect_to '/u/'+name
		rescue
			flash[:error] = "Sorry, something went wrong. That name or list of movies already exists. Please try again."
			redirect_to '/'
		end
	end

	def all_users
		all_movies = User.get_all_movies()		

		all_movies.each_value do |value|
			value["ratings"] = User.get_array_avg(value["ratings"])
		end

		@sorted_movies = all_movies.sort_by {|k,v| [-v["ratings"], -v["names"].length]}
		
		return @sorted_movies
	#render :json => @sorted_movies
		
	end

	def my_movies

		@my_movies = User.get_my_movies(params[:name])
		@name = params[:name]

		return @my_movies, @name
		#render :json => @my_movies
	end




end
