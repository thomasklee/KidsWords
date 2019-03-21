# ---------------------------
# KidsWords project
# Test code: cleaning reported birth weight 
# Thomas Klee
# Created: 2019-03-18
# Updated: 2019-03-21
# ---------------------------

# This script contains code to be
# incorporated into other scripts after testing.

library(tidyverse)

# select variables  
clean_bw <- select(bw_test, PID, starts_with("cbirth_weight"))

# sample random subset of rows from data 
# clean_bw <- sample_n(clean_bw, 30)

# select first n rows of data
# clean_bw <- head(clean_bw, 50)

# create new variables from old by removing alphabetic characters
clean_bw$gram1 <- str_replace_all(clean_bw$cbirth_weight_g, "[:alpha:]", "")
clean_bw$lb <- str_replace_all(clean_bw$cbirth_weight_lb, "[:alpha:]", "")
clean_bw$oz <- str_replace_all(clean_bw$cbirth_weight_oz, "[:alpha:]", "")

# change class of character strings 
clean_bw$gram1 <- as.numeric(clean_bw$gram1)
clean_bw$lb <- as.numeric(clean_bw$lb)
clean_bw$oz <- as.numeric(clean_bw$oz)

# convert lb and oz to grams
clean_bw$lb2 <- clean_bw$lb * 453.59237
clean_bw$oz2 <- clean_bw$oz * 28.34952312

# replace NA with "0"
clean_bw$lb2[is.na(clean_bw$lb2)] <- 0
clean_bw$oz2[is.na(clean_bw$oz2)] <- 0
clean_bw$gram1[is.na(clean_bw$gram1)] <- 0

# add these together
clean_bw$gram2 <- clean_bw$lb2 + clean_bw$oz2

# create new variable
clean_bw$gram <- clean_bw$gram1 + clean_bw$gram2

# Some respondents reported birthweight in kg...
# convert kg to g for any value < 10
clean_bw$gram <- ifelse(clean_bw$gram < 10, clean_bw$gram * 1000, clean_bw$gram)

# round to nearest gram
clean_bw$gram <- round(clean_bw$gram, digits = 0)

# replace zero values with NA
clean_bw$gram <- ifelse(clean_bw$gram == 0, NA, clean_bw$gram)

# create new data frame having only original and recoded variables
clean_bw2 <- select(clean_bw, PID, cbirth_weight_g, cbirth_weight_lb, cbirth_weight_oz, gram)

# done to here -----

# remaining NA values in gram variable need to be cleaned
# may need to clean these one at a time

# identify rows where metric and imperial birth weights were entered
# since these get added together in grams variable
# unclean_rows <- bw_test %>%
#   filter(is.na(cbirth_weight_g, cbirth_weight_lb))


sessionInfo()
