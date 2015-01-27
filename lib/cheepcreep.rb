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
end



github = Github.new
github.get_user
#github.get_followers

binding.pry
#user = Cheepcreep::GitHubUser.create(JSON.parse(resp.body))

#creeper = CheepcreepApp.new
#reeper.creep


