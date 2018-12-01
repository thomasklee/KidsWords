# ---------------------------
# Text processing CDI longest utterances
# Thomas Klee
# Created: 2018-11-30
# Revised: 2018-12-01
# ---------------------------

library(tidyverse)
library(tidytext)

test <-
  CDI_text %>%
  drop_na() %>%
  filter(field == 30, session == 1) %>%
  select(text = response) # also renames "response" variable

test <- as_tibble(rownames_to_column(test))
test <- rename(test, line = rowname) 
test$line <- as.integer(test$line)

# divide text into word tokens
test2 <- test %>% unnest_tokens(word, text) 

# count word types, sort by frequency and plot
test2 %>%
  count(word, sort = TRUE) %>%
  filter(n > 25 & n < 50) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

# good to here
