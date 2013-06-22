##
# title: github-repowatch w/ active notifications
# author: @theoretick
# date: 2013-06-21
# url: https://github.com/theoretick/github-repowatch
#
#
# PCS Exam3 - week 3
#
# github repository watcher. runs persistently, checking every 5min for
# new commits to specified repo. Notifies w/ guard when new commit.

  # check specified github repo
  # notify last message
  # store SHA to compare to (currently uses URL)
  # sleep checking every 5 min
######################################################################

require 'nokogiri'
require 'open-uri'
require 'terminal-notifier-guard'

class RepoWatch

  attr_reader :path
  attr_reader :sha
  attr_reader :msg

  def initialize
    @reponame = 'ShaneDelmore/critic_critic'
    @path = "https://github.com/#{@reponame}/commits/master"
    puts @path
  end

  def checkGithub
    commit_page = Nokogiri::HTML(open(@path))
    commit = commit_page.css('a.message').first
    if commit["href"] != @sha
      @sha = commit["href"] # shortcut: url will be unique. no need to parse
      @msg = commit.content
      return true
    else
      return false
    end
  end

  def notify(reponame)
    # the success notification is prettier than "notify()"
    TerminalNotifier::Guard.success(
      "MSG: '#{@msg}'",
      title:"Push to #{reponame.upcase}",
      # subtitle:@sha, # disabled until SHA is parsed, else too long
      open:@path,
      group:reponame)
    # sleep 6 # apparently the minimum wait to cleanly remove from NSNotify
    TerminalNotifier::Guard.remove(reponame)
  end

  def start
    loop do # runs forever, checking every 5 minutes
      check = checkGithub
      if check == true
        notify(@reponame)
      end
      puts "check again in 5min at #{Time.now}"
      sleep 300 # sleep for 5 minutes, check again
    end
  end

end

# UNCOMMENT TO RUN AS STANDALONE
g = RepoWatch.new
g.start
