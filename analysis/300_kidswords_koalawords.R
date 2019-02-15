# ---------------------------
# KidsWords project
# Age of acquisition of Koala wordlist
# Thomas Klee
# Created: 2019-02-14
# Revised: 2019-20-15
# ---------------------------

# This script produces AoA plots of 9 early words

# load packages
library(tidyverse)

# select data from full data set
wordlist <- CDI_words %>%
  select(session, camos, response, resp, CDI_item ) %>%
  filter(session == "1") %>%
  filter(camos >= 16 & camos <= 30) %>%
  filter(CDI_item == "nose" | CDI_item == "eye" | CDI_item == "mouth" | 
           CDI_item == "duck" | CDI_item == "car" | CDI_item == "flower" | 
           CDI_item == "balloon" | CDI_item == "shoe" | CDI_item == "water")

# create summary table (but may not be needed given new code below)
temp <- wordlist %>%
  group_by(CDI_item, camos) %>% 
  summarise(pctsaid = mean(resp), n = length(resp))

# good to here

# recode Says as 1 and NA as 0



temp <- wordlist %>%
  group_by(CDI_item, camos) %>%
  summarise(n = n(), pctkids = length(CDI_item))

temp summarise(PctKids = mean(CDI_item), n = length(CDI_item))

test <- temp %>% summarise(PctKids = nrow(camos), n = nrows(CDI_item))


ggplot(wordlist, 
       aes(x = camos, y = test$n) + 
         theme_light() + geom_line(color = "red") + geom_point() + 
         scale_x_continuous(name = "\n Age in months", breaks = seq(16, 30, 2)) + 
         scale_y_continuous(name = "Proportion of children\n", limits = c(0, 1), breaks = seq(0, 1, .2)) +
         facet_wrap(~CDI_item)
)

  

# =========================

# Create word list to be used in for-loop
word.list <- names(table(WordFeatures$CDI_Item_Words))

# Count number of items in word list
N <- length(word.list)

# Use dplyr to sort data by word and age then calculate proportion of children at each month of age 
AgeofAcq <- data1 %>%
  group_by(CDI_Item_Words, CA) %>%
  summarise(PctKids = mean(CDI_Says_Words), n = length(CDI_Item_Words))

# Plot sorted data on separate graphs and save graphs as PDF files
for(i in 10:12){
  pdf(file = paste('AoA_', word.list[i],'.pdf'), width = 5, height = 5)
  AoA <- AgeofAcq %>% filter(CDI_Item_Words == word.list[i])
  print(
    ggplot(AoA, aes(x = CA, y = PctKids)) + theme_light() + geom_line(color = "red") + geom_point() +      scale_x_continuous(name = "\n Age in months", breaks = seq(16, 30, 2)) + 
      scale_y_continuous(name = "Proportion of children\n", limits = c(0, 1), breaks = seq(0, 1, .2)) +
      ggtitle(word.list[i])
  )
  dev.off()
}
