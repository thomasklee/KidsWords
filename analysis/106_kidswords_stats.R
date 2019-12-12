# ---------------------------
# KidsWords project
# Calculate ideal group sizes based on parent education 
# Thomas Klee
# Created: 2019-12-12
# ---------------------------

# This script calculates the ideal sample size of each group
# based on the proportion of mothers in the population 
# at each education level, based on NZ census.

library(tidyverse)

CDIPQ <- read.csv("data/data_CDIPQ.csv") 

# select data for CDI normative study
xs <- CDIPQ %>% 
  filter(session == 1,  camos >= 16 & camos <= 30, mono_env == "yes")

# calculate size of cross-sectional sample
N <- (nrow(xs))

# calculate current size of each education group
noqual_N <- nrow(filter(xs, pedcat == 0)) 
somesec_N <-  nrow(filter(xs, pedcat == 1))
sec_N <- nrow(filter(xs, pedcat == 2))
univ_N <- nrow(filter(xs, pedcat == 3))

# results
noqual_N
somesec_N
sec_N
univ_N

# based on current sample size, 
# calculate ideal size of each group in proportion to population 
# (proportions from Table 5 of manuscript)
ideal_noqual <- .127 * N
ideal_somesec <- .246 * N
ideal_sec <- .355 * N
ideal_univ <- .271 * N

# results (obviously cannot be achieved given current data set)
ideal_noqual
ideal_somesec
ideal_sec
ideal_univ

# check N based on ideal group sizes 
sizecheck <- ideal_noqual + ideal_somesec + ideal_sec + ideal_univ
sizecheck

# assuming no further data will be collected,
# adjust size of each group relative to 
# size of smallest current group (noqual: n = 40);
# round to whole numbers

adj_somesec <- round((40 * 24.6) / 12.7, 0)
adj_sec <- round((40 * 35.5) / 12.7, 0)
adj_univ <- round((40 * 27.1) / 12.7, 0)

# results
adj_somesec
adj_sec
adj_univ

# total size of hypothetical adjusted sample
adj_N <- noqual_N + adj_somesec + adj_sec + adj_univ
adj_N

# calculate reduction of ideal sample from current sample
reduced_N <- round(1 - (adj_N / N), 2)
reduced_N

# clean up
rm(N)
rm(ideal_noqual)
rm(ideal_sec)
rm(ideal_somesec)
rm(ideal_univ)
rm(adj_N)
rm(adj_sec)
rm(adj_somesec)
rm(adj_univ)
rm(sizecheck)
rm(reduced_N)
rm(noqual_N)
rm(sec_N)
rm(somesec_N)
rm(univ_N)
