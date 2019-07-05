require "sinatra"
require "octokit"
require "dotenv/load"

configure { set :github, Octokit::Client.new(access_token: ENV.fetch("GITHUB_ACCESS_TOKEN")) }

before { halt 200 unless params["fax"].nil? || params["fax"].empty? }

post "/newsletter" do
  halt 400 if params["email"].nil? || params["email"].strip.empty?
  settings.github.add_comment "leafac/www.leafac.com--data", 1, "#{params["name"]&.strip} <#{params["email"].strip}>\n#{params["description"]}"
  erb "<p>Thank you for subscribing to my newsletter.</p>"
end
