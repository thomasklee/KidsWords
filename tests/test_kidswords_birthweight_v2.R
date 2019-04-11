# ---------------------------
# KidsWords project
# Test code: cleaning reported birth weight 
# Thomas Klee
# Created: 2019-03-18
# Updated: 2019-03-22
# ---------------------------

# This script contains code to be added to 02_kidswords_dataprep.R script.
# Its purpose is to clean respondents' input to 3 parent questionnaire
# categories related to children's birth weight. 

library(tidyverse)

# select variables  
bw <- select(PQ, PID, starts_with("cbirth_weight"))

# sample random subset of rows from data 
# bw <- sample_n(bw, 30)

# select first n rows of data
# bw <- head(bw, 50)

# create new variables from old by removing alphabetic characters
bw$gram1 <- str_replace_all(bw$cbirth_weight_g, "[:alpha:]", "")
bw$lb <- str_replace_all(bw$cbirth_weight_lb, "[:alpha:]", "")
bw$oz <- str_replace_all(bw$cbirth_weight_oz, "[:alpha:]", "")

# change class of character strings 
bw$gram1 <- as.numeric(bw$gram1)
bw$lb <- as.numeric(bw$lb)
bw$oz <- as.numeric(bw$oz)

# convert lb and oz to grams
bw$lb2 <- bw$lb * 453.59237
bw$oz2 <- bw$oz * 28.34952312

# where lb was entered but not oz, convert NA's to 0
bw$oz2 <- (ifelse(bw$lb2 > 0 & is.na(bw$oz2), 0, bw$oz2))

# add these together
bw$gram2 <- bw$lb2 + bw$oz2

# create new variable
# if both metric and imperial weights were reported, use metric
bw$gram <- ifelse((bw$gram1 > 0 & bw$gram2 > 0), bw$gram1, bw$gram2)
bw$gram <- ifelse((bw$gram1 > 0 & is.na(bw$gram2)), bw$gram1, bw$gram)
bw$gram <- ifelse((is.na(bw$gram1) & bw$gram2 > 0), bw$gram2, bw$gram)

# Some respondents reported birthweight in kg, so
# convert kg to g for any value < 10
bw$gram <- ifelse(bw$gram < 10, bw$gram * 1000, bw$gram)

# round to nearest gram
bw$gram <- round(bw$gram, digits = 0)

# create new data frame having only original and recoded variables
bw2 <- select(bw, PID, cbirth_weight_g, cbirth_weight_lb, cbirth_weight_oz, gram)

# get summary statistics for birth weight in grams
summary(bw2$gram)

library(pastecs)
stat.desc(bw2$gram, basic = TRUE, norm = TRUE)

library(psych)
describe(bw2$gram)

# find rows with missing gram data and save as CSV file for printing
missing_bw <- bw2[is.na(bw2$gram), ] %>% 
  print(n = 80)

write.csv(missing_bw, file = "data/missing_bw.csv")

# from the print-out, add lines to 02_kidswords_dataprep.R, 
# correcting for incorrect NA values in the 'gram' variable. 

# remove temporary objects from environment
# rm(bw, bw2, missing_bw)

# ---------------------------
# code below was used for testing purposes

# identify rows where both metric and imperial birth weights were entered
# since these get added together in 'gram', resulting in incorrect sum
# unclean_rows <- bw %>%
#   filter(!is.na(cbirth_weight_g) & !is.na(cbirth_weight_lb)) 

# when both metric and imperials weights were reported, use metric
# unclean_rows$cbirth_weight_g <- ifelse(!is.na(unclean_rows$cbirth_weight_g) & !is.na(unclean_rows$cbirth_weight_lb), unclean_rows$cbirth_weight_g, 0)

# unclean_rows$gram2 <- ifelse((unclean_rows$gram1 > 0 & unclean_rows$gram2 > 0), (unclean_rows$gram2 <- 0), unclean_rows$gram2)

sessionInfo()
