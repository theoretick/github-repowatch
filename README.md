
##PCS Exam3 - week 3

git repo watcher with active notifications

# github repository watcher.

Repository checker that runs persistently, checking at 5min intervals
for new commits to specified repo.  Notifications sent via Guard when
new commits are pushed.

 * check specified github repo
 * notify last message
 * store SHA to compare to (currently uses URL)
 * sleep checking every 5 min

###FUTURE:
 * takes repo name from user (no longer hardcoded)
 * multiple repos/branches to watch
   - (how to differentiate?)
 * add alert bell along with pop-up
 * notify author
 * notify SHA
 * click notification to open commit