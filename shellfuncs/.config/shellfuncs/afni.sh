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

