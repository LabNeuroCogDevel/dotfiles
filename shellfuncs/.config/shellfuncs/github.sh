
# create a repo on github 
# githubrepo repo_name [optional: group]
# use GITUSER from env, default to WillForan
function githubrepo {
   # bail if we dont have what we want
   [ -z "$1" ] && echo "need a repo name" && return 1
   rname="$1"

   # default user, remote path, and "group"
   [ -z "$GITUSER" ] && GITUSER=WillForan
   rpath='user/repos'
   group="$GITUSER"

   # if we want the repo to be owed by an actual group
   # that is, we have a second argument
   # reset the defaults
   if [ -n "$2" ]; then 
     group="$2" 
     rpath="orgs/$group/repos"
   fi

   ! curl -u "$GITUSER" https://api.github.com/$rpath -d "{\"name\":\"$rname\"}" && echo "failed!" && exit 1
   echo git remote add origin git@github.com:$group/$rname.git
   echo git push origin master
   echo git push --set-upstream origin master
}

## create a github repo
function mygithubnew {
   [ -z "$1" ] && echo "need a repo name" && return 1
   githubrepo "$1" 
   #   ! curl -u 'WillForan' https://api.github.com/user/repos -d "{\"name\":\"$1\"}" && echo "failed!" && exit 1
   #   echo git remote add origin git@github.com:WillForan/$1.git
   #   echo git push origin master
   #   echo "git push --set-upstream origin master"
}
function githubnew {
   [ -z "$1" ] && echo "need a repo name" && return 1
   githubrepo "$1"  LabNeuroCogDevel
   #   ! curl -u 'WillForan' https://api.github.com/orgs/LabNeuroCogDevel/repos -d "{\"name\":\"$1\"}" && echo "failed!" && exit 1
   #   echo git remote add origin git@github.com:LabNeuroCogDevel/$1.git
   #   echo git push origin master
   #   echo "git push --set-upstream origin master"
}

