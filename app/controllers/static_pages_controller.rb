class StaticPagesController < ApplicationController
  	def home
  	end
	
	def upload
		user_data = Hash.new
		@movies_json = Hash.new
		final = Hash.new
		movies = params[:movies]
		name = params[:name]

		user_data["name"] = name
		
		File.open(Rails.root.join('public', 'uploads', movies.original_filename), 'wb') do |file|			
			@movies_json = movies.read			
		end
		
		user_data["movies"] = @movies_json
		user = User.create_new_user(user_data)
		session[:name] = name
	  	redirect_to '/my'
		
	end

	def all_users
		@things = User.get_all_movies()
		
		render :text => current_user.movies
	end

	def my_movies
		
		@my_movies = User.get_my_movies(current_user.name)
		
		return @my_movies		
	end




end
