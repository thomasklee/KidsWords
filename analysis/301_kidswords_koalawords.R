# ---------------------------
# KidsWords project
# Age of acquisition of Koala 9 words
# Thomas Klee
# Created: 2019-02-14
# Revised: 2019-02-19
# ---------------------------

# This script produces AoA plots of 9 early words for girls and boys

# load packages
library(tidyverse)

# select data from full data set
wordlist <- CDI_words %>%
  select(session, camos, csex, response, resp, CDI_item ) %>%
  filter(session == "1") %>%
  filter(camos >= 16 & camos <= 30) %>%
  filter(CDI_item == "nose" | CDI_item == "eye" | CDI_item == "mouth" | 
           CDI_item == "duck" | CDI_item == "car" | CDI_item == "flower" | 
           CDI_item == "balloon" | CDI_item == "shoe" | CDI_item == "water")

# create summary table:
# proportion of kids producing each word by age
AoA_table <- wordlist %>%
  group_by(CDI_item, camos, csex) %>% 
  summarise(prop_said = mean(resp), n = length(resp))

AoA_table <- as.data.frame(AoA_table)

# create graphs of each word
p <- ggplot(data = AoA_table, mapping = aes(x = camos, y = prop_said, colour = csex))
            
p + theme_light() + 
  geom_line() + 
  geom_point() + 
  scale_x_continuous(name = "\n Age in months", breaks = seq(16, 30, 2)) + 
  scale_y_continuous(name = "Proportion of children\n", limits = c(0, 1), breaks = seq(0, 1, .2)) +
  labs (title = "Age of acquisition of Koala words for girls and boys based on NZ CDI:WS (N = 2,581) \n") +
  facet_wrap(~CDI_item)

# save plot as PDF
ggsave(filename = "figures/koala9_sex.pdf")
