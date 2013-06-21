#
# PCS Exam3 - week 3
#
# git repo watcher w/ active notifications
#
# runs persistently, checking every 5min for new commits to specified
# repo. Notifies via notification-center/guard when new commit


require 'nokogiri'
require 'open-uri'
require 'terminal-notifier-guard'

class RepoWatch

  attr_accessor :path
  attr_reader :sha

  def initialize
    @reponame = 'theoretick/PCS-exam2'
    @path = "https://github.com/#{@reponame}/commits/master"
  end

  def checkGithub
    commit_page = Nokogiri::HTML(open(@path))
    # @sha = commit_page.
    @msg = commit_page.css('a.message').first.content
    notify(@msg)
  end

  def notify(reponame)
    if sha.nil?
    else
      TerminalNotifier::Guard.notify("New Push to #{reponame}",group:reponame)
      sleep 6 # apparently the minimum wait to cleanly remove from NSNotify
      TerminalNotifier::Guard.remove(reponame)
    end
  end

  def start
    # NOTE -- unauth limit 60 per hour
    # check github
    # notify last SHA
    # store SHA to compare to
    # sleep checking every 5 min
    # notify if SHA~1 !== SHA
  end

end

g = RepoWatch.new
g.start
