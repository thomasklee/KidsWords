# ---------------------------
# KidsWords Project
# Test code
# Thomas Klee
# Created: 2017-12-14
# Updated: 2017-12-15
# ---------------------------

# This script contains code to be
# incorporated into other scripts after testing.

library(tidyverse)

# clean up birth weights ------------------------
# examples of data entered by parents into web form;
# parents given option of reporting birthweight in grams or in lbs + oz

# create messy data frame
PID <- c(1, 2, 3, 4, 5, 6)
cbirth_weight_g <- c("", "", "", "2900 grams", "", "1800")
cbirth_weight_lb <- c("6 lbs", "7", "8lb", "", "", "4lbs")
cbirth_weight_oz <- c("10oz", "3 oz", "7", "", "", "0oz")
bwdata <- data.frame(PID, cbirth_weight_g, cbirth_weight_lb, cbirth_weight_oz)

# same data in a csv file
bwdata <- read_csv("data/bwdata.csv")

# make a copy 
bwdata2 <- bwdata

# strip out alphabetic strings; declare as numeric; add to dataframe
lb <- as.numeric(str_extract_all(bwdata2$cbirth_weight_lb, "[0-9]+"))
oz <- as.numeric(str_extract_all(bwdata2$cbirth_weight_oz, "[0-9]+"))
g <- as.numeric(str_extract_all(bwdata2$cbirth_weight_g, "[0-9]+"))

# create functions to convert lb and oz to grams
grams1 <- function(x) lb*453.592
grams2 <- function(x) oz*28.35

# execute functions
grams1(lb)
grams2(oz)

# add the two results and round to nearest gram
bwdata2$cbirth_weight <- round(grams1(lb) + grams2(oz), digits = 0)

# if parents entered data in g, lbs and oz, then use gram data
bwdata2$cbirth_weight <- ifelse(!is.na(g), g, bwdata2$cbirth_weight)

# display messy and tidy data frames
bwdata  # messy
bwdata2  # tidy

# remove temporary objects
rm(PID, lb, oz, g, cbirth_weight_g, cbirth_weight_lb, 
   cbirth_weight_oz, grams1, grams2)

sessionInfo()