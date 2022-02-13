# ----------------------------------------------
# load required packages
# ----------------------------------------------
if(!suppressWarnings(require(httr))) install.packages("httr", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(dplyr))) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(jsonlite))) install.packages("jsonlite", repos = "http://cran.us.r-project.org")

# ----------------------------------------------
# load API KEY
# ----------------------------------------------
# # temp path
# setwd('C:/Users/user/PJT/Study/11.Dashbord/Covid19View')
load('./DATA/environment.Rdata')


