MAXJOBS=5
SLEEPTIME=100 #seconds

#                                        #
# IMPOVERISHED JOB MANAGEMENT WITH BASH  #
#                                        #

# *****************************************************
#                DO NOT COPY PASTE
# *****************************************************
# a copy of this file should be sourced from your script
# e.g.
#    source jobcontrol.bash
#


# USAGE:
#   0. copy this file into your project dirctory (esp if you plan to adjust settings)
#   1. source this file
#   2. call 'waitforjobs' inside loop where jobs are forked w/&
#   3. consider adding 'wait' to end of loop so you dont exit early
#
# EXAMPLE:
#
#   source jobcontrol.bash
#   for d in subj/*; do
#     ./thingThatWillTakeAwhile $d &
#     waitforjobs "last ran $d"
#   done
#   wait
# 
# #see also: `waitforjobsexample` at bottom of file
#
#
# ADVANCE:
#   change maxjob or sleetime values while script is running to
#   e.g. allocate more jobs when another processor opens up
#
#   N.B. decreasing number of jobs 
#        will NOT change the number of jobs currently launched!

#
#   if you really want to copy this function into your own script
#   ** remove 'source "$thisfile"'  **
#   or you'll put the computer into a death spiral. see 'fork bomb'


function waitforjobs {

  # msg is anything passed to the function
  msg="$@"
  
  # how many jobs are running now?
  njobs=$(jobs -p |wc -l)

  # we can change the def. of max jobs and sleeptime in real time
  thisfile="${BASH_SOURCE[0]}"
  [ -n "$thisfile" ] && thisfile=$( cd $(dirname $thisfile); pwd)/$(basename $thisfile);


  # hit this loop as long as we are at our max jobs 
  while [ $njobs -ge $MAXJOBS ]; do
     # print msg if we have one
     [ -n "$msg" ]  && echo "$(date): $msg (MAXJOBS:$MAXJOBS, SLEEPTIME: $SLEEPTIME)"

     # update SLEEPTIME and MAXTIME if we've sourced this function from a file
     [ -r "$thisfile" ] && source "$thisfile"  # potential fork bomb

     sleep $SLEEPTIME

     # update running jobs count
     njobs=$(jobs -p |wc -l)

  done

}

function waitforjobsexample {
   # source jobcontrol.sh
   for i in {1..100}; do
     sleep 10 &
     waitforjobs "last ran sleep # $i"
   done
   wait
}
