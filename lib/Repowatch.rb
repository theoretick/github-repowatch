#
require 'nokogiri'
require 'open-uri'
require 'terminal-notifier-guard'

class RepoWatch

  VERBOSE = true

  attr_reader :path
  attr_reader :sha
  attr_reader :msg

  def initialize(inrepo, branch='master')
    @reponame = inrepo
    @path = "https://github.com/#{@reponame}/commits/#{branch}"
    display("Now watching '#{@path}'...")
  end

  def display(message)
    # [NOTE]: must be instance method for access to instance vars??
    # display checks for VERBOSE setting, if on, displays stuff
    if VERBOSE == false
      puts message
    end
  end

  def get_response
    begin
      page_response = open(@path)
    rescue OpenURI::HTTPError
        puts "ERROR, Repo not found: '#{@path}'"
        puts "Exiting..."
        exit
    end
    page_noko = Nokogiri::HTML(page_response)
    return page_noko
  end

  def checkGithub
    # checks github, returns true if watched repo is updated, else false
    commit_page = get_response

    commit = commit_page.css('a.message').first
    if commit["href"] != @sha
      @sha = commit["href"] # shortcut: URL is unique. no need to parse SHA
      @msg = commit.content
      display("Latest commit: #{@sha} \n #{@msg}")
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
    # TerminalNotifier::Guard.remove(reponame)
  end

  def start
    loop do # runs forever, checking every 5 minutes
      check = checkGithub
      if check == true
        notify(@reponame)
      end
      display("check again in 5min at #{Time.now}")
      sleep 180 # sleep for 3 minutes, check again
    end
  end

end

