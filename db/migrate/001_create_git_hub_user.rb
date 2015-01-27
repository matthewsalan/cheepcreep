class CreateGitHubUser < ActiveRecord::Migration
	def self.up
		create_table :git_hub_users do |t|
			t.string :login
			t.string :name
			t.string :blog
			t.integer :pub_repos
			t.integer :followers
			t.integer :following
		end
	end

	def self.down
		drop_table :github_users
	end
end
