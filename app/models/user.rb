#!/bin/env ruby
# encoding: utf-8

class User < ActiveRecord::Base
	
	def self.create_new_user(user_data)
	  create! do |user|
	    user.name = user_data["name"]
	    user.movies = user_data["movies"]
	  end
	end

	def self.get_all_movies()
		movie_hash = Hash.new
		all_users = User.all
		all_users.each do |user|
			movies_json = JSON.parse(user.movies)
			movies_json.each do |movie|
				if movie_hash[movie["movieName"]]
					movie_hash[movie["movieName"]]["ratings"] << Float(movie["rating"])
					movie_hash[movie["movieName"]]["names"] << user.name
				else
					movie_hash[movie["movieName"]] = {'url' => movie["url"], 'names' => [user.name], 'ratings' => [Float(movie["rating"])]}
				end
			end			
		end

		movie_hash.each_value {|value| }

		#movie_list.sort_by! { |f| [-Float(f['rating'])] }

		#movie_names = []
		#movie_list.each do |movie|
		#	movie_names.push(movie["movieName"])
		#end

		return movie_hash
	end

	def self.get_my_movies(name)
		user = User.find_by_name(name)
		
		my_movies = [name]

		movies_json = JSON.parse(user.movies)
		movies_json.each do |movie|
			my_movies.push(movie)				
		end			

		all_movies = User.get_all_movies()
		my_movies.each { |k| all_movies.delete k["movieName"] }

		all_movies.each_value do |value|
			value["ratings"] = get_array_avg(value["ratings"])
		end

		sorted_movies = all_movies.sort_by {|k,v| [-v["ratings"], -v["names"].length]}
		
		return sorted_movies

	end

	def self.get_array_avg(arr)
		total = arr.inject(:+)
		len = arr.length
		average = total.to_f / len
		return average
	end

end
