# ---------------------------
# KidsWords Project
# Data preparation-03
# Thomas Klee
# Created: 2017-06-09
# Updated: 2018-08-10
# ---------------------------

library(tidyverse)

# This script:
# calculates CDI word total and grammatical complexity score for each child;
# merges the CDI data with selected variables from the parent questionnaire;
# recodes 11 peduc categories into 4 summary categories and orders them;
# summarizes the variables. 

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
CDIdata <- select(CDIdata, PID, session, DOB, DOS, camos, cadays, wordtotal, gctotal, resp.x, resp.y)  # reorders variables

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
  select(PID, csex, cbirth_order, ctwin, cdaycare, region, prelation, cborn_in_nz, ccountry_where,
         cmain_lang, cother_langs, cwhich_langs, mono_env,
         family_hist, peduc, cethnicity_nz, cethnicity_other)

# use dplyr's inner_join() instead of merge() so that variables previously defined 
# as factors don't become character strings
CDIPQ <- inner_join(CDIdata, PQdata, by = "PID")

# aggregate peduc codes (0-9) into a new variable (pedcat)
# using Statistics NZ categories and declare as an ordered factor:
# 0 = no qualification
# 1 = level 1-2 certificates (some secondary qualification)
# 2 = level 3-4 certificates and level 5-6 diplomas (secondary education certs and dips)
# 3 = level 7-10 undergrad and postgrad degrees and grad and postgrad 
# certs and dips (university degree)
# 11 = level 11 overseas secondary school qualification
CDIPQ$pedcat <- recode(CDIPQ$peduc,
                       '0' = "0",
                       '1' = "1",
                       '2' = "1",
                       '3' = "2",
                       '4' = "2",
                       '5' = "2",
                       '6' = "2",
                       '7' = "3",
                       '8' = "3",
                       '9' = "3",
                       '10' = "3",
                       '11' = "2"
)

CDIPQ$pedcat <- ordered(CDIPQ$pedcat)

glimpse(CDIPQ)

summary(CDIPQ)

# save CDIPQ data frame with variable formats intact
saveRDS(CDIPQ, file = "data/data_CDIPQ.RDS")
# add "CDIPQ <_readRDS("data_CDIPQ.RDS")" near beginning of kidswords1.Rnw to use data in manuscript

# convert data frame to csv file; factor and date formats will be lost
# no need to use any further but might be useful to give someone else
write_csv(CDIPQ, "data/data_CDIPQ.csv") 

# remove temporary data frames
rm(CDI_long)
rm(PQed)
rm(wordtotals)
rm(gctotals)
rm(CDI_wc)
rm(CDI_comp)
rm(CDI_wide)

sessionInfo()
