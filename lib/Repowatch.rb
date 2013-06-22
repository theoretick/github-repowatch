
require 'nokogiri'
require 'open-uri'
require 'terminal-notifier-guard'

class RepoWatch

  attr_reader :path
  attr_reader :sha
  attr_reader :msg

  def initialize(inrepo, branch='master')
    @reponame = inrepo
    @path = "https://github.com/#{@reponame}/commits/#{branch}"
    puts @path
  end

  def get_response
    page_response = Nokogiri::HTML(open(@path))
    return page_response
  end

  def checkGithub
    # checks github, returns true if watched repo is updated, else false
    commit_page = get_response()

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
      "'#{@msg}'",
      title:"NEW COMMIT:",
      subtitle:"#{reponame}",
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

