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
  
  def initialize(user = "matthewsalan", pass = "KaG39cNxiXaRfE")
    @auth = {:username => user, :password => pass}
  end

  def get_followers(user = "redline6561", options = {}) #{:page => {:page => page}}
  	options.merge!({:basic_auth => @auth})
  	resp = self.class.get("/users/#{user}/followers", options) 
    #puts "#{resp.headers['x-ratelimit-emaining']} requests left"
  	JSON.parse(resp.body)
  end

  def get_user(user = "matthewsalan", options = {})
  	options.merge!({:basic_auth => @auth})
  	resp = self.class.get("/users/#{user}", options)
  	JSON.parse(resp.body)
  end

  def get_all_users(user = "redline6561", options = {})
  	options.merge!({:basic_auth => @auth})
  	resp = self.class.get("/users/#{user}/followers", options)
  	all_users = JSON.parse(resp.body)

  	user_info = []
  	all_users.each do |x|
  		user_info << get_user(x['login'])
  	end
  	return user_info
  end

  def get_gists(user = "matthewsalan", options = {})
    options.merge!({:basic_auth => @auth})
    resp = self.class.get("/users/#{user}/gists")
    JSON.parse(resp.body)
  end
  
  def create_gist(user = "matthewsalan", options = {}, info = {:description => "the description for this gist", :public => true, :files => {"file1.txt" => {:content => "String file contents"}}})
    options = {:body => info.to_json}
    options.merge!({:basic_auth => @auth})
    resp = self.class.post("/gists", options)
  end

  def list_gists(user = "matthewsalan", option = {})
    option.merge!({:basic_auth => @auth})
    resp = self.class.get("/users/#{user}/gists")
    JSON.parse(resp.body)
  end

  def get_file_as_string(filename)
    data =''
    f = File.open(filename, 'r')
    f.each_line do |line|
      data += line
    end
    return data
  end
  
  #TODO
  # def edit_gist
  # end

  def delete_gist(id, options ={})
    options.merge!({:basic_auth => @auth})
    self.class.delete("/gists/#{id}", options)
  end

  def star_gist(id, options = {})
    options.merge!({:basic_auth => @auth})
    self.class.put("/gists/#{id}/star", options)
  end

  def unstar_gist(id, options = {})
    options.merge!({:basic_auth => @auth})
    self.class.delete("/gists/#{id}/star", options)
  end

end

def put_users_into_database(input)
  input.each do |x|
    Cheepcreep::GitHubUser.create(:login => x['login'], :name => x['name'], :blog => x['blog'], :pub_repos => x['pub_repos'], 
                                  :followers => x['followers'], :following => x['following'])
  end
end

#array = []

github = Github.new
github.list_gists
#array = github.get_all_users
#put_users_into_database(array)
#github.get_followers

binding.pry
#user = Cheepcreep::GitHubUser.create(JSON.parse(resp.body))

#creeper = CheepcreepApp.new
#reeper.creep


# def update_user(:name => nil, :email => nil, :blog => nil, :location => nil )
#   contents = {:name => name, :email => email, :blog => blog, :location => location}
#   options = {:body => contents.to_json}
#   result = self.class.patch('/user', options)
# end