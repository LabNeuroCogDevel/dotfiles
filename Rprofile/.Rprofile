# this should probably go into Rprofile.site
#
# CRANmirror
options(repos=structure(c(CRAN="http://lib.stat.cmu.edu/R/CRAN")))
#options(repos=structure(c(CRAN="https://cran.revolutionanalytics.com")))
LNCDupdateLib <- function() {
  nitoolslibpath <-'/opt/ni_tools/Rlib/'
  if(file.exists(nitoolslibpath)){
    # exapand path to include version
    nitoolslibpath <- paste0(nitoolslibpath,version$major,'.', version$minor)
    if( nitoolslibpath %in% .libPaths() ) { return(T) }
    if(!file.exists(nitoolslibpath)) dir.create(nitoolslibpath)
    .libPaths(nitoolslibpath)
    return(T)
  } 
  return(F) 
}
invisible( LNCDupdateLib() )



updatePrompt <- function(...) {options(prompt=format(Sys.time(), "\n# %X\n#> ")); return(TRUE)}

.First <- function(...) {

  ### fancy prompt
  # check that we are interactive, that we are not in Rstuido (via libPahts) or emacs/ESS (STERM iESS or dumb term)
  isdumb <- options('STERM')=='iESS'       ||    # emacs
            Sys.getenv('INSIDE_EMACS')!='' ||    # emacs
            Sys.getenv('TERM') == 'dumb'   ||    # no color term
            Sys.getenv('RSTUDIO') == '1'   ||    # rstudio
            Sys.getenv('NVIMR_ID') != ''   ||    # nvim-r
            Sys.getenv("RADIAN_VERSION") != ""   # radian
  


   # radian settings
   if( Sys.getenv("RADIAN_VERSION") != "" ){
      options(
        radian.prompt = "\033[0;32m>\033[0m ",
        radian.shell_prompt = "\033[0;31m#!>\033[0m ",
        radian.browse_prompt = "\033[0;33mBrowse[{}]>\033[0m ",
        radian.enable_reticulate_prompt = TRUE
      )
     library(colorout)

   }

  # nothing below is good for a dumb/emacs/rstudio R instance
  # only useful if we are using interative mode (and we arent in R studio)
  if(isdumb || !interactive()) return()

  ## PROMPT
  # add blue and pink colors to the prompt
  updatePrompt <- function(...) {options(prompt=format(Sys.time(), 
     #"\n# [38;5;27m%X[0;0m\n#[38;5;197m>[0;0m "
     "\n[38;5;197m# [38;5;27m%X[0;0m\n "
     )); return(TRUE)}

 # add prompt changing function as task callback when we are interactive
 # N.B R has to execute code (cannot just hit enter for new time)
 addTaskCallback(updatePrompt)
 updatePrompt()

 # console R session, add color
 library(colorout)
}

undoRprofile <- function() {
   removeTaskCallback(1)
   options(prompt="> ")
   .First <- function() return(T)
   .Last <- function() return(T)
}

cli_colortheme_change <-function(){
   system('/home/ni_tools/dynamic-colors/bin/dynamic-colors cycle')
}


# scripting alaiases
#s <- base::summary;
#h <- utils::head;
#n <- base::names;



##
## http://www.cookbook-r.com/Graphs/Plotting <- means <- and <- error <- bars <- (ggplot2)/#Helper functions
##

## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
    require(plyr)

    # New version of length which can handle NA's: if na.rm==T, don't count them
    length2 <- function (x, na.rm=FALSE) {
        if (na.rm) sum(!is.na(x))
        else       length(x)
    }

    # This is does the summary; it's not easy to understand...
    datac <- ddply(data, groupvars, .drop=.drop,
                   .fun= function(xx, col, na.rm) {
                           c( N    = length2(xx[,col], na.rm=na.rm),
                              mean = mean   (xx[,col], na.rm=na.rm),
                              sd   = sd     (xx[,col], na.rm=na.rm)
                              )
                          },
                    measurevar,
                    na.rm
             )

    # Rename the "mean" column    
    datac <- rename(datac, c("mean"=measurevar))

    datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean

    # Confidence interval multiplier for standard error
    # Calculate t-statistic for confidence interval: 
    # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
    ciMult <- qt(conf.interval/2 + .5, datac$N-1)
    datac$ci <- datac$se * ciMult

    return(datac)
}


xinit = "NA"
