# ---------------------------
# KidsWords project
# CDI item frequencies and AoA
# Thomas Klee
# Created: 2019-04-24
# Revised: 
# ---------------------------

# This script produces item frequencies and AoA plots for 
# predicates and closed-class items

# load packages
library(tidyverse)
library(ggforce) # for output pagination

# select predicates from full data set
predlist <- CDI_words %>%
  select(session, camos, response, resp, CDI_item, field) %>%
  filter(session == "1") %>%
  filter(camos >= 16 & camos <= 30) %>%
  filter(field == 14 | field == 15)

# select closed-class items from full data set
closedlist <- CDI_words %>%
  select(session, camos, response, resp, CDI_item, field) %>%
  filter(session == "1") %>%
  filter(camos >= 16 & camos <= 30) %>%
  filter(field == 17 | field == 18 | field == 19 |
         field == 20 | field == 21 | field == 22)

# summarise predicate data

# create summary table:
# proportion of kids producing each word by age
pred_table <- predlist %>%
  group_by(CDI_item, camos) %>% 
  summarise(prop_said = mean(resp), n = length(resp))

pred_table <- as.data.frame(pred_table)

# create graphs of each word
pred_plots <- ggplot(data = pred_table, mapping = aes(x = camos, y = prop_said))
            
p + theme_light() + 
  geom_line() + 
  geom_point() + 
  scale_x_continuous(name = "\n Age in months", breaks = seq(16, 30, 2)) + 
  scale_y_continuous(name = "Proportion of children\n", limits = c(0, 1), breaks = seq(0, 1, .2)) +
  labs (title = "Reported predicate use based on NZ CDI:WS (N = 2,581) \n") +
#  geom_vline(xintercept = 24) +
  geom_hline(yintercept = .8) +
  facet_wrap_paginate(~CDI_item, ncol = 3, nrow = 3, page = 1)

# save each page as PDF using RStudio Plot | Export

# save plot as PDF
ggsave(filename = "figures\predicate_items.pdf")
