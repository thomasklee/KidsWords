# ---------------------------
# KidsWords Project
# Data preparation-03
# Thomas Klee
# Created: 9 June 2017
# Updated: 15 June 2017
# ---------------------------

library(tidyverse)

# This script:
# calculates the total number of CDI words for each child in session 1,
# merges the CDI data with selected variables from the parent questionnaire,
# and summarizes the variables.

# Depends on the output of prior scripts:
# 01_kidswords_dataprep.R
# 01_kidswords_dataprep.R

# select CDI word items in session 1 (each child's 1st CDI) 
# for kids from 16 through 30 months of age 
# and calculate vocabulary size of each 
wordtotals <- CDI_words %>% 
  filter(sem_field <= 22, session == 1,  camos > 15, camos < 31) %>% 
  select(PID, session, camos, cadays, sem_field, CDI_item, itemID, resp) %>% 
  group_by(PID, session) %>% 
  summarise(wordtotal = sum(resp)) 

# first attempt (not used) since it excluded any child whose word total was zero
# test <- CDI_words %>% 
#   filter(sem_field <= 22, session == 1,  camos > 15, camos < 31, response == "Says") %>% 
#   select(PID, session, camos, cadays, sem_field, CDI_item, itemID, response) %>% 
#   group_by(camos, PID) %>% 
#   summarise(words = n()) %>% 
#   select(PID, camos, words)  # reorder variables

# merge wordtotals with other variables
CDIdata <- merge(wordtotals, CDI_wide, by = c("PID", "session"))  ## merge(x, y) uses an inner_join
CDIdata <- select(CDIdata, PID, session, DOB, DOS, camos, cadays, wordtotal)  # reorder variables

# select relevant variables from parent quesionnaire
PQdata <-
  PQ %>% 
  select(PID, csex, cbirth_order, ctwin, cdaycare, region)

# merge CDI and PQ variables
CDIPQ <- merge(CDIdata, PQdata, by = "PID")

# convert data frame to csv file
write_csv(CDIPQ, "data/data_CDIPQ.csv")

glimpse(CDIPQ)

summary(CDIPQ)

sessionInfo()
