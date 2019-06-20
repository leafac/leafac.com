require "sinatra"
require "octokit"
require "dotenv/load"

configure { set :github, Octokit::Client.new(access_token: ENV.fetch("GITHUB_ACCESS_TOKEN")) }

post "/newsletter" do
  halt 400 if params["email"].nil? || params["email"].strip.empty?
  settings.github.add_comment "leafac-bot/www.leafac.com", 1, "#{params["name"]&.strip} <#{params["email"].strip}>\n#{params["description"]}"
  erb "<p>Thank you for subscribing to my newsletter.</p>"
end
