require "sinatra"
require "octokit"
require "dotenv/load"

configure { set :github, Octokit::Client.new(access_token: ENV.fetch("GITHUB_ACCESS_TOKEN")) }

post "/newsletter" do
  unless params["name"       ].nil? || params["name"       ].strip.empty? ||
         params["email"      ].nil? || params["email"      ].strip.empty? ||
         params["description"].nil? || params["description"].strip.empty?
     settings.github.add_comment "leafac/www.leafac.com--data", 1, "#{params["name"]} <#{params["email"]}>\n#{params["description"]}"
  end
  redirect "https://www.leafac.com/newsletter"
end
