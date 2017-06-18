# ---------------------------
# KidsWords Project
# Data preparation-03
# Thomas Klee
# Created: 9 June 2017
# Updated: 18 June 2017
# ---------------------------

library(tidyverse)

# This script:
# calculates the total number of CDI words for each child in session 1,
# merges the CDI data with selected variables from the parent questionnaire,
# and summarizes the variables.

# Depends on the output of prior scripts:
# 01_kidswords_dataprep.R
# 01_kidswords_dataprep.R

# calculate CDI vocabulary size
# based on session 1 (each child's 1st CDI) 
# ages 16 through 30 months 
wordtotals <- CDI_words %>% 
  filter(field <= 22, session == 1,  camos > 15, camos < 31) %>% 
  select(PID, session, camos, cadays, field, CDI_item, itemID, resp) %>% 
  group_by(PID, session) %>% 
  summarise(wordtotal = sum(resp)) 

# =============================================

# calculate CDI grammatical complexity score
# based on session 1 (each child's 1st CDI) 
# ages 16 through 30 months 

# select all CDI items with ("Says" or NA) response options 
# 
CDI_words <- CDI_words %>% 
  filter(field < 23 | between(field, 25, 28))

# -------------

# CDI Section E: Complexity
# find records in Section E (field = 31) with resp = 1, and replace with 0
# find records in Section E with resp = 2 and replace with 1
# "resp" recoding of original "response" variable was done previous (with 0) 
# https://stackoverflow.com/questions/40705807/replace-values-on-condition-in-r
CDI_words[CDI_words$field == 31 & CDI_words$resp == "1", c("resp")] <- "0"
CDI_words[CDI_words$field == 31 & CDI_words$resp == "2", c("resp")] <- "1"

# ==============================================

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
