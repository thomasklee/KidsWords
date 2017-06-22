# ---------------------------
# KidsWords Project
# Data preparation-03
# Thomas Klee
# Created: 09 June 2017
# Updated: 22 June 2017
# ---------------------------

library(tidyverse)

# This script:
# calculates CDI word total and grammatical complexity score for each child;
# merges the CDI data with selected variables from the parent questionnaire;
# and summarizes the variables.

# Note that no filters have been applied for age or session number.

# Depends on the output of prior scripts:
# 01_kidswords_dataprep.R
# 02_kidswords_dataprep.R

# calculate CDI vocabulary size
wordtotals <- CDI_words %>% 
  filter(field <= 22) %>% 
  select(PID, session, camos, cadays, field, CDI_item, itemID, resp) %>% 
  group_by(PID, session) %>% 
  summarise(wordtotal = sum(resp)) 

# calculate CDI grammatical complexity score
gctotals <- CDI_words %>% 
  filter(field == 31) %>% 
  select(PID, session, camos, cadays, field, CDI_item, itemID, resp) %>% 
  group_by(PID, session) %>% 
  summarise(gctotal = sum(resp)) 

# extract comprehension question from CDI and declare as factor
CDI_comp <- CDI_words %>% 
  filter(CDI_item == "1_B4") %>% 
  select(PID, session, CDI_item, response, resp) %>% 
  group_by(PID, session)

# extract word combinations question from CDI and declare as factor
CDI_wc <- CDI_words %>% 
  filter(CDI_item == "word_comb") %>% 
  select(PID, session, CDI_item, response, resp) %>% 
  group_by(PID, session)

# merge wordtotals and gctotals
CDI_measures <- merge(wordtotals, gctotals, by = c("PID", "session"))

# merge with CDI_comp
CDI_measures <- merge(CDI_measures, CDI_comp, by = c("PID", "session"))

# merge with CDI_wc
CDI_measures <- merge(CDI_measures, CDI_wc, by = c("PID", "session"))

# merge CDI_measures with other variables
CDIdata <- merge(CDI_measures, CDI_wide, by = c("PID", "session"))  ## merge(x, y) uses an inner_join
CDIdata <- select(CDIdata, PID, session, DOB, DOS, camos, cadays, wordtotal, gctotal, resp.x, resp.y)  # reorder variables

# rename variables
CDIdata <- rename(CDIdata,
             CDI_comp = resp.x,
             CDI_wc = resp.y)

# declare variables as factors
CDIdata$CDI_comp <- factor(CDIdata$CDI_comp)
CDIdata$CDI_wc <- factor(CDIdata$CDI_wc)

# select relevant variables from parent quesionnaire
PQdata <-
  PQ %>% 
  select(PID, csex, cbirth_order, ctwin, cdaycare, region, prelation, cborn_in_nz, family_hist, peduc)

# merge CDI and PQ variables
CDIPQ <- merge(CDIdata, PQdata, by = "PID")

# convert data frame to csv file
write_csv(CDIPQ, "data/data_CDIPQ.csv")

glimpse(CDIPQ)

summary(CDIPQ)

# remove temporary data frames
rm(wordtotals)
rm(gctotals)
rm(CDI_wc)
rm(CDI_comp)
rm(CDI_wide)

sessionInfo()
