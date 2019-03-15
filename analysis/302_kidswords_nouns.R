# ---------------------------
# KidsWords project
# Age of acquisition of nouns
# Thomas Klee
# Created: 2019-02-14
# Revised: 2019-02-21
# ---------------------------

# This script produces AoA plots of noun use by girls and boys

# load packages
library(tidyverse)
library(ggforce) # for output pagination

# select data from full data set
wordlist <- CDI_words %>%
  select(session, camos, csex, response, resp, CDI_item, word_class) %>%
  filter(session == "1") %>%
  filter(camos >= 16 & camos <= 30) %>%
  filter(word_class == "n")

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
  labs (title = "Reported noun use for girls and boys based on NZ CDI:WS (N = 2,581) \n") +
  geom_vline(xintercept = 24) +
  geom_hline(yintercept = .8) +
  facet_wrap_paginate(~CDI_item, ncol = 3, nrow = 8, page = 1)

# save each page as PDF using RStudio Plot | Export

# save plot as PDF
# ggsave(filename = "figures/nouns_by_sex.pdf")
