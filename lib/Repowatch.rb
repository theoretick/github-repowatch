#
require 'nokogiri'
require 'open-uri'
require 'terminal-notifier-guard'

class RepoWatch

  VERBOSE = true # provide substantial message feedback on CL

  attr_reader :path
  attr_reader :sha
  attr_reader :msg

  def initialize(inrepo, branch='master')
    @reponame = inrepo
    @path = "https://github.com/#{@reponame}/commits/#{branch}"
    display("Now watching '#{@path}'...")
  end

  def display(message)
    # display checks for VERBOSE setting, if on, displays stuff
    # [NOTE]: must be instance method for access to instance vars??
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
    return page_response
  end

  def parse_http_response(http_response)
    # parses http w/ nokogiri and returns first commit
    parsed_response = Nokogiri::HTML(http_response)
    commit = parsed_response.css('a.message').first
    return commit
  end

  def check_github
    # checks github, returns true if watched repo is updated, else false
    page_response = get_response

    commit = parse_http_response(page_response)

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
    TerminalNotifier::Guard.success( # success() prettier than notify()
      "'#{@msg}'",
      title:"NEW COMMIT:",
      subtitle:"#{reponame}",
      open:@path,
      group:reponame)
    # TerminalNotifier::Guard.remove(reponame)
  end

  def start
    loop do # runs forever, checking every 5 minutes
      check = check_github
      notify(@reponame) if check == true
      display("check again in 5min at #{Time.now}")
      sleep 180 # sleep for 3 minutes, check again
    end
  end

end

