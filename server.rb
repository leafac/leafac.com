require "sinatra"
require "octokit"
require "dotenv/load"

configure { set :github, Octokit::Client.new(access_token: ENV.fetch("GITHUB_ACCESS_TOKEN")) }

post "/newsletter" do
  redirect "https://www.leafac.com/#newsletter" if params["email"].nil? || params["email"].strip.empty?
  settings.github.add_comment "leafac/www.leafac.com--data", 1, "#{params["name"]&.strip} <#{params["email"].strip}>\n#{params["description"]}"
  redirect "https://www.leafac.com/?newsletter-subscribed#newsletter"
end
