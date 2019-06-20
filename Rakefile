task default: :test

desc "Test website"
task :test do
  require "html-proofer"
  sh "bundle exec jekyll build"
  HTMLProofer.check_directory("./_site", assume_extension: true).run
end

desc "List emails for newsletter"
task(:newsletter) { puts github.issue_comments("leafac-bot/www.leafac.com", 1).map { |issue| issue.body.lines.first.strip }.join(", ") }

def github
  @github ||= begin
    require "./server"
    Sinatra::Application.new.settings.github
  end
end
