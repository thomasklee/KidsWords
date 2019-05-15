# ---------------------------
# KidsWords project
# Data preparation-04
# Thomas Klee
# Created: 2019-05-14
# Revised: 2019-05-15
# ---------------------------

# This script retrieves data from several sources
# so that frequency counts of children's first names can be done.

# load packages
library(tidyverse)
library(lubridate)

# KidsWords.accdb was a MS Access database  
# designed to keep records of those expressing 
# interest in participating. That participants
# database stored children's names.

# load CSV files
namedata <- read_csv("data/tb_Passwords.csv") # exported from KidsWords.accdb on 2019-05-14
users <- read_delim("data/Kidswords_user_children_20161201.csv", delim = ";")

# CSV file contains surnames and other confidential information, so
# only select relevant variables
namedata <- namedata %>% 
  select(Password_pwd, cFirstName_pwd, Email_date_pwd)

# simplify variable names (new = old)
namedata <- rename(namedata, 
                firstname = cFirstName_pwd,
                emaildate = Email_date_pwd
)

# change dates to ISO 8601 format
namedata$emaildate <- dmy(namedata$emaildate) # turns out we don't need this

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
names <- inner_join(users, namedata, by = "Password_pwd")

# merge test and xs data frames to identify those who participated at Time 1
names <- inner_join(names, xs, by = "PID")

# select relevant variables for analysis
names <- names %>% 
  select(firstname, csex) # PID not selected to keep things anonymous

# display data frame structure
str(names)

# convert firstnames from characters to factor
names$firstname <- as.factor(names$firstname)

# display data frame structure and first 6 rows
str(names)
head(names)

# create CSV file from data frame
write_csv(names, "data/data_names.csv")

# remove temporary data frames
rm(namedata)
rm(users)
