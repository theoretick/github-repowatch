#
# PCS Exam3 - week 3
#
# git repo watcher w/ active notifications
#
# runs persistently, checking every 5min for new commits to specified
# repo. Notifies via notification-center/guard when new commit

  # check github
  # notify last SHA
  # store SHA to compare to
  # sleep checking every 5 min
  # FUTURE -- notify if SHA~1 !== SHA
######################################################################

require 'nokogiri'
require 'open-uri'
require 'terminal-notifier-guard'

class RepoWatch

  attr_accessor :path
  attr_reader :sha
  attr_reader :msg

  def initialize
    @reponame = 'theoretick/PCS-exam2'
    @path = "https://github.com/#{@reponame}/commits/master"
    puts @path
  end

  def checkGithub
    commit_page = Nokogiri::HTML(open(@path))
    commit = commit_page.css('a.message').first
    @sha = commit["href"]
    @msg = commit.content
  end

  def notify(reponame)
    # if sha.nil?
    #   message = nil
    # else
    #   message = @msg
    # end
    TerminalNotifier::Guard.notify("New Push to #{reponame} \n SHA: #{@sha} \n Message: #{@msg}",group:reponame)
    sleep 6 # apparently the minimum wait to cleanly remove from NSNotify
    TerminalNotifier::Guard.remove(reponame)
  end

  def start
    # loop do
      # runs forever, checking every 5 minutes
      checkGithub
      notify(@reponame)
      sleep 300 # sleep for 5 minutes, check again
    # end
  end

end
