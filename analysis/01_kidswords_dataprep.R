# ---------------------------
# KidsWords project
# Data preparation-01
# Thomas Klee
# Created: 18 Apr 2017
# Revised: 24 Apr 2017
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
library(lubridate)

# load CDI data
CDI_temp <- read_csv("data/Kidswords_cdi_replies_011216.csv")

# load parent questionnaire data
PQ_temp <- read_csv("data/Kidswords_scl_replies_011216.csv")

# remove variables containing sensitive information
# including child's name, respondent's name, phone numbers, email address
PQ_temp <- select(PQ_temp, -i_1_1, -i_2_1, -i_1_28, -i_1_29, -i_1_30) 

# remove unused variable
CDI_temp <- select(CDI_temp, -WAVE)

# remove records added during website's test phase
CDI_temp <- filter(CDI_temp, CHILD_ID > 20502)
PQ_temp <- filter(PQ_temp, SCL_ID > 20502)
CDI_temp <- filter(CDI_temp, CHILD_ID != 22376)
PQ_temp <- filter(PQ_temp, SCL_ID != 22376)

# remove "Learning to Talk" participants (records 22029 to 22196)
CDI_temp <- filter(CDI_temp, CHILD_ID < 22029 | CHILD_ID > 22196)
PQ_temp <- filter(PQ_temp, SCL_ID < 22029 | SCL_ID > 22196)

# correct data entry dates for paper-based CDIs manually entered 
# into kidswords.org by RAs from 72 parents initially recruited for
# Learning to Talk, but not enrolled in that project.
# dates below were written on paper CDI forms by parents
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "2uS4Ug", "07-12-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "BRene9", "11-08-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "c8A3up", "13-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "j9k7MA", "17-10-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "cHuK8S", "10-11-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "sefR5B", "24-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "3pE5ET", "09-08-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "8Pa7Pu", "23-09-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "FruS79", "22-09-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "SpEr7P", "10-12-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "Quy29a", "30-11-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "stuk45", "12-08-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "z7cr9s", "30-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "s8atre", "29-07-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "4ejuk2", "01-07-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "th39ru", "11-07-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "n5phe5", "14-05-12")) 
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "6eteza", "30-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "6hechu", "21-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "2umuch", "28-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "jepad6", "24-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "breqa6", "22-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "3hawu9", "30-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "phawa6", "04-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "je7uhA", "03-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "3U9Ruj", "16-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "f6wuHe", "20-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "cr2qEp", "16-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "fr6wRe", "22-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "NA2e8U", "23-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "TapR6d", "16-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "h3FEvu", "23-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "SteP4a", "18-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "2acRuT", "29-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "KEs6e4", "25-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "wEth5y", "09-07-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "c8uZAc", "25-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "D4Ayap", "18-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "3uCetE", "12-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "3Hut5F", "25-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "7weC5u", "28-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "yaxA6r", "12-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "mUX5Pa", "28-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "puqAh9", "22-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "gUCa3u", "04-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "qaVa58", "06-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "trUfA8", "30-07-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "Z5s2Uf", "03-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "vA3rap", "04-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "ku64Da", "09-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "7U5Asp", "30-05-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "C2Az5S", "13-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "6esPUT", "01-07-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "sWU65x", "28-07-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "cuW3ru", "22-08-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "ch7reT", "26-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "4raTHa", "13-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "3h2zuW", "19-09-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "S6nAcH", "10-09-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "St7Rad", "10-09-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "QeDr4F", "09-10-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "7awrA6", "26-08-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "T4Ucha", "19-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "WabU6a", "24-01-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "sPEt6e", "30-08-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "9UStam", "16-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "7ebeBr", "26-10-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "had6aM", "19-06-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "Z3p2ub", "04-11-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "fatHa7", "12-08-12"))
CDI_temp <- mutate(CDI_temp, FILLEDOUT = replace(FILLEDOUT, CHILD_PASSWORD == "F9e9re", "22-10-12"))

# convert data frames to csv files for further, anonymised data analysis
write_csv(PQ_temp, "data/data_PQ.csv")
write_csv(CDI_temp, "data/data_CDI.csv")

# remove data frames no longer needed
rm(CDI_temp, PQ_temp)

sessionInfo()
