# ---------------------------
# KidsWords project
# Children's first names
# Thomas Klee
# Created: 2019-05-15
# Revised: 
# ---------------------------

# This script creates counts of first names
# so that ranked distributions of names
# in the sample and population can be compared.

# load packages
library(tidyverse)
library(stringr)
library(wordcloud)

# uses PQ raw data as data source;
# since this contains confidential information the code below has been commented out.
# the active part of the script begins below by importing a processed CSV data file.

# load parent questionnaire raw data
# PQ_temp <- read_csv("data/Kidswords_scl_replies_011216.csv")

# rename variables
# PQ_temp <- rename(PQ_temp, PID = SCL_ID, cname = i_1_1)

# merge PQ_temp with xs data frame 
# names <- inner_join(PQ_temp, xs, by = "PID")

# select relevant variables: child's ID, name and sex 
# names <- select(names, PID, csex, cname) 

# uses word() function from stringr package
# select first word of cname, declare it as factor, and add it to data frame
# names <- mutate(names, firstname = as.factor(word(names$cname,1))) 

# display data frame structure and first 6 rows
# str(names)
# head(names)

# select variables needed (not cname, since some entries contain surnames)
# names <- names %>% 
#   select(firstname, csex)

# display first 6 rows
# head(names)

# create CSV file from data frame
# write_csv(names, "data/data_names.csv")

# remove object
# rm(names)

# code above only needed to generate data/data_names.csv file
# so it has been commented out

names <- read.csv("data/data_names.csv")

# display data frame structure and first 6 rows
str(names)
head(names)

# create two new data frames and summarise them
girlnames <- names %>% 
  filter(csex == "Girl")
summary(girlnames)

boynames <- names %>% 
  filter(csex == "Boy")
summary(boynames)

# done to here ---------------------

# Create wordcloud for boys' names

# Create subset of data for boys
boydata <- data[cSex_pq == "Boy",]

# Create 'words' argument for wordcloud containing list of unique first names
words <- boydata$cFirstName_pwd

# Create 'freq' argument for wordcloud containing number of children with each name
# require(plyr)
freq <- count(boydata, "words")

# Sort freq with names occurring in decreasing order of occurrence
freq <- freq[order(-freq$freq),]
freq

# Create wordcloud based on frequency of names
# require(wordcloud)

boycloud <- wordcloud(freq$words, freq$freq, scale=c(4,.5),min.freq=3,max.words=50,random.order=FALSE,
                      rot.per=.35,colors=brewer.pal(8, "Paired"),use.r.layout=FALSE)

###########################################################################

# Create wordcloud for girls' names; previous variables will be overwritten

# Create subset of data for girls
girldata <- data[cSex_pq == "Girl",]

# Create 'words' argument for wordcloud containing list of unique first names
words <- girldata$cFirstName_pwd

# Create 'freq' argument for wordcloud containing number of children with each name
# require(plyr)
freq <- count(girldata, "words")

# Sort freq with names occurring in decreasing order of occurrence
freq <- freq[order(-freq$freq),]
freq

# Create wordcloud based on frequency of names
# require(wordcloud)

girlcloud <- wordcloud(freq$words, freq$freq, scale=c(4,.5),min.freq=3,max.words=50,random.order=FALSE,
                       rot.per=.35,colors=brewer.pal(8, "Set2"),use.r.layout=FALSE)

