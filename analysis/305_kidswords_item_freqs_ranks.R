# ---------------------------
# KidsWords project
# CDI item frequencies and ranks by age
# Thomas Klee
# Created: 2019-04-30
# Revised: 
# ---------------------------

# This script calculates ranked item frequencies 
# for predicates and closed-class items at each month of age

# load packages
library(tidyverse)

# get data
CDI_words <- read.csv("data/data_CDI_words.csv")

# select predicate items
predicates <- CDI_words %>%
  select(session, camos, response, resp, CDI_item, field) %>%
  filter(session == "1") %>%
  filter(camos >= 16 & camos <=30) %>%
  filter(field == 14 | field == 15)

# create summary table
pred_table <- predicates %>%
  group_by(camos, CDI_item) %>% 
  summarise(n_said = sum(resp), prop_said = round(mean(resp), digits = 3), n = length(resp)) %>%
  arrange(camos, desc(prop_said))

pred_table <- as.data.frame(pred_table)

# display summary table
pred_table

# select closed-class
closedclass <- CDI_words %>%
select(session, camos, response, resp, CDI_item, field) %>%
filter(session == "1") %>%
filter(camos >= 16 & camos <= 30) %>%
filter(field == 17 | field == 18 | field == 19
       | field == 20 | field == 21 | field == 22)

# create summary table
closedclass_table <- closedclass %>%
  group_by(camos, CDI_item) %>% 
  summarise(n_said = sum(resp), prop_said = round(mean(resp), digits = 3), n = length(resp)) %>%
  arrange(camos, desc(prop_said))

closedclass_table <- as.data.frame(closedclass_table)

# display summary table
closedclass_table
