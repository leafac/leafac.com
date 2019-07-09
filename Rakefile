require "./server"

desc "List emails for newsletter"
task(:newsletter) { puts github.issue_comments("leafac/www.leafac.com--data", 1).map { |issue| issue.body.lines.first.strip }.join(", ") }

def github() @github ||= Sinatra::Application.new.settings.github end
