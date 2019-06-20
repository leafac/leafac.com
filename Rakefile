require "./server"

def github() @github ||= Sinatra::Application.new.settings.github end

desc "List emails for newsletter"
task(:newsletter) { puts github.issue_comments("leafac-bot/www.leafac.com", 1).map { |issue| issue.body.lines.first.strip }.join(", ") }
