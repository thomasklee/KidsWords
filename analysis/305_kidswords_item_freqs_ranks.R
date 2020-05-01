# ---------------------------
# KidsWords project
# CDI item frequencies and ranks by age
# Thomas Klee
# Created: 2019-04-30
# Revised: 2019-05-01
# ---------------------------

# This script calculates ranked item frequencies 
# for predicates and closed-class items at each month of age

# load packages
library(tidyverse)

# get data
CDI_words <- read.csv("data/data_CDI_words.csv")

# select action items
action_items <- CDI_words %>%
  select(session, camos, response, resp, CDI_item, field) %>%
  filter(session == "1") %>%
  filter(camos >= 16 & camos <=30) %>%
  filter(field == 14)

# create summary table
action_table <- action_items %>%
  group_by(camos, CDI_item) %>% 
  summarise(n_said = sum(resp), prop_said = round(mean(resp), digits = 3), n = length(resp)) %>%
  arrange(camos, desc(prop_said))

action_table <- as.data.frame(action_table)

# display summary table
action_table

# ------------------------
# select descriptive items
descriptive_items <- CDI_words %>%
  select(session, camos, response, resp, CDI_item, field) %>%
  filter(session == "1") %>%
  filter(camos >= 16 & camos <=30) %>%
  filter(field == 15)

# create summary table
descriptive_table <- descriptive_items %>%
  group_by(camos, CDI_item) %>% 
  summarise(n_said = sum(resp), prop_said = round(mean(resp), digits = 3), n = length(resp)) %>%
  arrange(camos, desc(prop_said))

descriptive_table <- as.data.frame(descriptive_table)

# display summary table
descriptive_table

# -------------------
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
