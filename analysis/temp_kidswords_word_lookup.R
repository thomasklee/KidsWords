# ---------------------------
# KidsWords project
# temp_kidswords_word_lookup.R
# Revise word lookup information
# Thomas Klee
# Created: 2019-04-24
# Updated: 
# ---------------------------

# This script adds 'CDI_part' variable to the lookup table.
# Its purpose is to identify how each value
# of the 'field' variable is labelled on the NZCDI:WS.
# This should improve how individual lexical items
# are isolated using filter() since some lexical items
# occur in more than one field.

# Once the new variable has been added to the lookup
# table, 02_kidswords_dataprep.02 needs to be re-run.
# this script can then be scrapped.

# load library
library(tidyverse)
        
# load lookup table of CDI vocabulary characteristics
word_lookup <- read_csv("data/cdi_lookup.csv")

# create new variable using dplyr format (new_name = current_name)
word_lookup <- word_lookup %>% 
  mutate(CDI_part = field) 

# change values of new variable
word_lookup <- word_lookup %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 1, "sound_effects")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 2, "animals")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 3, "vehicles")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 4, "toys")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 5, "food_drink")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 6, "clothing")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 7, "body_parts")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 8, "household_items")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 9, "furniture_rooms")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 10, "outside_things")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 11, "places_to_go")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 12, "people")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 13, "games_routines")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 14, "action_words")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 15, "descriptive_words")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 16, "time_words")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 17, "pronouns")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 18, "question_words")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 19, "prepositions_locations")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 20, "quantifiers_articles")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 21, "helping verbs")) %>% 
  mutate(CDI_part = replace(CDI_part, CDI_part == 22, "connecting_words"))

# rearrange columns
word_lookup <- select(word_lookup, itemID, CDI_item, field, CDI_part, word_class, syllables,
                      syl_structure, ND, WF, WL, IPC)

# convert to data frame
word_lookup <- as.data.frame(word_lookup)

# convert data frame to CSV file
write_csv(word_lookup, "data/cdi_lookup.csv")

sessionInfo()
