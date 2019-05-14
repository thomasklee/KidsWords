# ---------------------------
# KidsWords project
# Data preparation-04
# Thomas Klee
# Created: 2019-05-14
# Revised: 
# ---------------------------

# This script retrieves data from several sources
# so that frequency counts of children's first names can be done.

# load packages
library(tidyverse)
library(lubridate)

# KidsWords.accdb was a MS Access database  
# designed to keep records of those expressing 
# interest in participating. 

# load CSV files
names <- read_csv("data/tb_Passwords.csv") # exported from KidsWords.accdb on 2019-05-14
users <- read_delim("data/Kidswords_user_children_20161201.csv", delim = ";")

# CSV file contains surnames and other confidential information, so
# only select relevant variables
names <- names %>% 
  select(Password_pwd, cFirstName_pwd, Email_date_pwd)

# simplify variable names (new = old)
names <- rename(names, 
                firstname = cFirstName_pwd,
                emaildate = Email_date_pwd
)

# change dates to ISO 8601 format
names$emaildate <- dmy(names$emaildate) # turns out we don't need this

# we need these variables: 
# users$childID # same as CDIPQ$PID
# users$childReferenceID # same as names$Password_pwd
# users$chiid$Gender # same as CDIPQ$csex

# duplicate variables so their names can be used when merging data frames
users <- users %>% 
  mutate(PID = childID)

users <- users %>% 
  mutate(Password_pwd = childReferenceID)

# merge data frames
test <- inner_join(users, names, by = "Password_pwd")

# merge test and xs data frames to identify those who participated at Time 1
test2 <- inner_join(test, xs, by = "PID")
head(test2)

# select relevant variables for analysis
test3 <- test2 %>% 
  select(PID, firstname, csex)
head(test3)
str(test3)

# create CSV file from data frame
write_csv(test3, "data/data_test3.csv")

# remove temporary data frames
rm(names)
rm(names2)
rm(users)
rm(test)
rm(test2)
rm(test3)
