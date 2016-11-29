# CRANmirror
options(repos=structure(c(CRAN="http://lib.stat.cmu.edu/R/CRAN")))


# fancy prompt

.First <- function(...) {
  if(interactive()) {  

    # add blue and pink colors to the prompt
    updatePrompt <- function(...) {

      # Emacs Speaks Stats, use default prompt
      if(options('STERM')=='iESS' || options('pager')=='cat') 
           options(prompt="> ") 

      # Rstudio -- time but no colors
      else if( any(grepl("RStudio", .libPaths())) )
           options(prompt=format(Sys.time(), "\n# %X\n#> "))

      # command line R
      else 
            options(prompt=format(Sys.time(),
                            "\n[38;5;197m# [38;5;27m%X[0;0m\n "))
      return(TRUE)
    }
  
    # not in Rstudio, otherwise it would have added itself to libPaths
    if(! any(grepl("RStudio", .libPaths()))){

      # need utils to use install packages stuff
      #library(utils)

      # install missing packages
      #basepkg <- c('dataview','setwidth','devtools','pacman') #'vimcom',
      #install.packages( basepkg [! basepkg %in% installed.packages() ] )

      # colorout is not in cran
      if(! 'colorout' %in% utils::installed.packages() ) devtools::install_github("jalvesaq/colorout")
      if(! 'vimcom' %in% utils::installed.packages() ) devtools::install_github("jalvesaq/VimCom")

      library(colorout) 
      # pacman can be used to check+install other packages
      if(! 'pacman' %in% utils::installed.packages() ) utils::install.packages('pacman')
      library(pacman)

      #  load (or install) others in cran
      p_load(dataview) 
      p_load(setwidth)
      p_load(vimcom)

    }

    # add prompt changing function as task callback when we are interactive
    # N.B R has to execute code (cannot just hit enter for new time)
    addTaskCallback(updatePrompt)
    #updatePrompt() # if we do this we get nice colors on terminal right away, but lock up ESS

    # load some other useful packages
    # plyr before dplyr so we still have plyr functions, but mask outdated with dplyr's
    p_load('stats') # want dplyr filter to be loaded after stats::filter
    p_load('plyr')
    p_load('dplyr')
    p_load('tidyr')
  }

}

# if rstudio:  detach("package:colorout")

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


options(repo="https://mirrors.nics.utk.edu/cran")
