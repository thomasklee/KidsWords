# ---------------------------
# KidsWords project
# Data preparation-01
# Thomas Klee
# Created: 18 Apr 2017
# Revised: 21 Apr 2017
# ---------------------------

# This script removes fields from the original data files
# downloaded from the KidsWords website back end that would 
# compromise participants' anonymity.

# The script also removes records of paricipants from the
# Learning to Talk project that were manually added to 
# kidswords.org by research assistants since these aren't to
# be used for the CDI normative study. It also removes records 
# that were part of the website's test phrase.

# -----------------------------------------------
# neither this script nor the original data files 
# should be pushed to GitHub
# -----------------------------------------------

# Data files received on 2016-12-01:
# KidsWords_cdi_replies_011216.csv
# Kidswords_sci_replies_011216.csv
# KidsWords_user_children_20161201.csv

# MS Access data not used -----------------------
# The data files above were originally imported to a MS Access database
# and processed there. Database queries were used to generate the 
# following data files:
# data1 <- read_csv("data/qry_statfile_T1_ID_CA_Sex_CDIwordtotal_20161201.csv") 
# data2 <- read_csv("data/qry_vocabulary_entry_all.csv")
# -----------------------------------------------

# load packages
library(tidyverse)

# load CDI data
CDI_temp <- read_csv("data/Kidswords_cdi_replies_011216.csv")

# load parent questionnaire data
PQ_temp <- read_csv("data/Kidswords_scl_replies_011216.csv")

# remove sensitive information from parent questionnaire data, including
# child's name, respondent's name, phone numbers, email address
PQ_temp <- select(PQ_temp, -i_1_1, -i_2_1, -i_1_28, -i_1_29, -i_1_30) 

# remove unused variable from CDI data
CDI_temp <- select(CDI_temp, -WAVE)

# remove records added during website's test phase
CDI_temp <- filter(CDI_temp, CHILD_ID > 20502)
PQ_temp <- filter(PQ_temp, SCL_ID > 20502)

# remove "Learning to Talk" participants (records 22029 to 22196)
CDI_temp <- filter(CDI_temp, CHILD_ID < 22029 | CHILD_ID > 22196)
PQ_temp <- filter(PQ_temp, SCL_ID < 22029 | SCL_ID > 22196)

# convert data frames to csv files for further, anonymised data analysis
write_csv(PQ_temp, "data/data_PQ.csv")
write_csv(CDI_temp, "data/data_CDI.csv")

# remove data frames no longer needed
rm(CDI_temp, PQ_temp)

sessionInfo()
