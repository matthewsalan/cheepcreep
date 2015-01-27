require "cheepcreep/version"
require "cheepcreep/init_db"
require "httparty"
require "pry"



module Cheepcreep
	class GitHubUser <ActiveRecord::Base
	end
end

class Github
  include HTTParty
  base_uri 'https://api.github.com'
   
  def initialize(user = "apitestfun", pass = "ironyard1")
    @auth = {:username => user, :password => pass}
  end

  def get_followers(input = "redline6561", options = {})
  	options.merge!({:basic_auth => @auth})
  	resp = self.class.get("/users/#{input}/followers", options)
  	JSON.parse(resp.body)
  end

  def get_user(input = "matthewsalan", options = {})
  	options.merge!({:basic_auth => @auth})
  	resp = self.class.get("/users/#{input}", options)
  	JSON.parse(resp.body)
  end

  def get_all_users(input = "redline6561", options = {})
  	options.merge!({:basic_auth => @auth})
  	resp = self.class.get("/users/#{input}/followers", options)
  	all_users = JSON.parse(resp.body)

  	user_info = []
  	all_users.each do |x|
  		user_info << get_user(x['login'])
  	end
  	return user_info
  end


end

def put_users_into_database(input)
  input.each do |x|
    Cheepcreep::GitHubUser.create(:login => x['login'], :name => x['name'], :blog => x['blog'], :pub_repos => x['pub_repos'], 
                                  :followers => x['followers'], :following => x['following'])
  end
end

array = []

github = Github.new
array = github.get_all_users
put_users_into_database(array)
#github.get_followers

#binding.pry
#user = Cheepcreep::GitHubUser.create(JSON.parse(resp.body))

#creeper = CheepcreepApp.new
#reeper.creep


