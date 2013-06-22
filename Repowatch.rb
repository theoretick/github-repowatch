##
# title: github-repowatch w/ active notifications
# author: @theoretick
# date: 2013-06-21
# url: https://github.com/theoretick/github-repowatch
#
#
# PCS Exam3 - week 3
# github repository watcher.
#
# runs persistently, checking every 5min for new commits to specified
# repo. Notifies via Guard when new commit.

  # check specified github repo
  # notify last message
  # store SHA to compare to (currently uses URL)
  # sleep checking every 5 min
######################################################################

require 'lib/Repowatch'

g = RepoWatch.new('ShaneDelmore/critic_critic')
g.start