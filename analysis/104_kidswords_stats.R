# ---------------------------
# KidsWords project
# Children's first names
# Thomas Klee
# Created: 2019-05-15
# Revised: 2019-12-05
# ---------------------------

# This script creates counts of first names
# so that the frequency of names in the sample 
# and population can be compared.

# Since the population data only include the 100 most 
# popular names for a given year, any rows with missing 
# population values (NA) are removed, even if the name
# was present in the sample. However, rows are removed
# only after combining data from all years.

# IMPORTANT: Since some of the CSV files used in this script contain
# confidential information, they have not been uploaded to GitHub.
# Instead, two anonymised CSV files have been uploaded to the 
# analysis/data folder for use with this script beginning at
# line 156.

# load packages
library(tidyverse)
library(lubridate)

# load data into data frame called CDIPQ using (tidyverse) readr's 
# read_csv() instead of read.csv() so that dates don't get changed
# to factors
CDIPQ <- read_csv("data/data_CDIPQ.csv")

# filter subset of CDIPQ data into xs
xs <- CDIPQ %>% 
  filter(session == 1,  camos >= 16 & camos <= 30, mono_env == "yes")

# display class of DOB variable
class(xs$DOB)

# display earliest and latest birth dates in the sample
range(xs$DOB)

# calculate how many children were born in each year
birthyear <- xs %>%
  select(DOB) %>% 
  group_by(year(DOB)) %>% 
  summarise(Total = n())

### Population data

# load data from NZ DIA spreadsheet into a data frame called pop_names
pop_names <- read.csv("data/popdata/nzdia_names.csv")

# count names of girls born in NZ from 2010 through 2013
pop_girls <- pop_names %>%
  filter(csex == "girl", source == "nzdia",
         year > 2009 & year < 2014) %>%
  group_by(source, firstname) %>% 
  summarise(n = sum(n)) %>% 
  arrange(desc(n))

head(pop_girls, 15)

# count names of boys born in NZ from 2010 through 2013
pop_boys <- pop_names %>%
  filter(csex == "boy", source == "nzdia",
         year > 2009 & year < 2014) %>%
  group_by(source, firstname) %>% 
  summarise(n = sum(n)) %>% 
  arrange(desc(n))

head(pop_boys, 15)

### Sample data

# create data frame by reading in raw data from Parent Questionnaires;
# CSV file surnames and other identifying information have been removed
sample_names <- read.csv("data/data_names.csv")

# create new factor to identify source of data
sample_names <- sample_names %>% 
  mutate(source = "sample")

# change variable from character to factor
sample_names$source <- as.factor(sample_names$source)

# get each child's DOB from the xs data frame;
dobs <- xs %>% 
  select(PID, DOB)

# merge DOB from dobs with names
sample_names <- inner_join(sample_names, dobs, by = "PID")

# regularize spelling by forcing first names to begin with capital letter;
# uses function from stringr package (part of tidyverse)
sample_names$firstname <- str_to_title(sample_names$firstname, locale = "en")

# remove PID and save for subsequent use
sample_names <- sample_names %>% 
  select(source, firstname, csex, DOB) %>% 
  write.csv("data/sample_names.csv")

# load anonymised data and display first 6 rows
sample_names <- read.csv("data/sample_names.csv")
head(sample_names)

# count and order names of girls born in NZ from 2010 through 2013
sample_girls <- sample_names %>%
  select(firstname, csex, source, DOB) %>% 
  filter(!is.na(firstname)) %>% 
  filter(csex == "Girl", source == "sample", 
         year(DOB) > 2009 & year(DOB) < 2014) %>% 
  count(firstname, sort = TRUE)

head(sample_girls, 15)

# count and order names of boys born in NZ from 2010 through 2013
sample_boys <- sample_names %>%
  select(firstname, csex, source, DOB) %>% 
  filter(!is.na(firstname)) %>% 
  filter(csex == "Boy", source == "sample", 
         year(DOB) > 2009 & year(DOB) < 2014) %>% 
  count(firstname, sort = TRUE)

head(sample_boys, 15)

# merge boys' firstnames, population counts and sample counts 
# into single data frame
boynames <- full_join(pop_boys, sample_boys, by = "firstname")

# display resulting data frame
head(boynames, 10)

# rename variables created from merging;
# completely unnecessary, but output more friendly
boynames <- boynames %>% 
  rename(population = n.x,
         sample = n.y)

# display data with renamed variables
head(boynames, 10)

# write data frame to file
write_csv(boynames, "data/boynames.csv")

# repeat for girls' firstnames
girlnames <- full_join(pop_girls, sample_girls, by = "firstname")

# rename variables created from merging;
# completely unnecessary, but output more friendly
girlnames <- girlnames %>% 
  rename(population = n.x,
         sample = n.y)

# display data with renamed variables
head(girlnames, 10)

# write data frame to file
write_csv(girlnames, "data/girlnames.csv")

# remove objects no longer needed
rm(birthyear)
rm(dobs)
rm(pop_boys)
rm(pop_girls)
rm(pop_names)
rm(sample_boys)
rm(sample_girls)
rm(sample_names)
rm(boynames)
rm(girlnames)

#------------------------------------------------ 
# Code below can be used on the following two CSV files;
# confidential data has been removed from them.

# Replace NAs with zeros in boynames and girlnames
# for statistical analysis. We don't want correlational
# analyses to drop rows where a name occurs in one but
# not both variables.

# Remove rows in which population value is NA but sample value is a number
# since the population data only contain the 100 most popular names.
# Rows containing population values but missing sample values are retained.

# read anonymised data from files 
boynames <- read_csv("data/boynames.csv")
girlnames <- read_csv("data/girlnames.csv")

# select variables
boynames <- boynames %>%
  select(firstname, population, sample)
girlnames <- girlnames %>%
  select(firstname, population, sample)

# change character variables to factors (not really necessary)
boynames$firstname <- as.factor(boynames$firstname)
girlnames$firstname <- as.factor(girlnames$firstname)

# display first 10 rows of each 
head(boynames, 10)
head(girlnames, 10)

# find rows containing NAs
is.na(boynames)
is.na(girlnames)

# replace missing sample values with zeros
boynames$sample <- ifelse(is.na(boynames$sample), 0, boynames$sample)
girlnames$sample <- ifelse(is.na(girlnames$sample), 0, girlnames$sample)

# exclude rows with missing population values
boynames <- na.omit(boynames, cols="population")
girlnames <- na.omit(girlnames, cols="population")

# calculate Pearson's correlation coefficients
boy_corr <- cor.test(boynames$population, boynames$sample,
                        method = "pearson", alternative = "g")

girl_corr <- cor.test(girlnames$population, girlnames$sample,
                         method = "pearson", alternative = "g")
