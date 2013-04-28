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
	
		begin 
			User.create_new_user(user_data)
			session[:name] = name
		  	redirect_to '/u/'+params[:name]
		rescue
			flash[:error] = "Sorry, something went wrong. That name or list of movies already exists. Please try again."
			redirect_to '/'
		end
	end

	def all_users
		@things = User.get_all_movies()
		
		render :text => @things
	end

	def my_movies

		@my_movies = User.get_my_movies(params[:name])
		@name = params[:name]

		return @my_movies, @name
	end




end
