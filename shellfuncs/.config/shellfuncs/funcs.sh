##
# some fun functions
# to make life easier
## 
function brikdiff {
 3dBrickStat -min -max -mean -var "3dcalc( -a $1 -b $2 -expr a-b )"
}

# quickly see two images in afni
# USAGE:
#   _afni mni functional.nii.gz *HEAD *nii*
#   _afni functional.nii.gz mask.nii.gz
function _afni {
 under=$1
 [ "$1" == "mni" ] && under="$HOME/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_csf_tal_nlin_asym_09c.nii"
 over=$2
 underafni=${under/nii/nii.gz} # afni is weird, even if not .nii.gz thats what it wants
 overafni=${over/nii/nii.gz}
 underafni=${underafni/gz.gz/gz} # afni is weird, even if not .nii.gz thats what it wants
 overafni=${overafni/gz.gz/gz}
 #AFNI_DETATCH=FALSE 
 afni -com "SET_UNDERLAY $(basename $underafni)" -com "SET_OVERLAY $(basename $overafni)" \
      -com "SET_THRESHNEW 0" -com "SET_FUNC_RANGE .5" $@
}

# this is dumb, just use 3dinfo -orient or something
function orients {
 3dinfo $@ |egrep 'Dataset\ File|\[-orient'|perl -sane 'print "\n" unless $F[$#F]=~s/\]//g; print "$F[$#F]\t"'|sort -k2d
}

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

