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

# calculate size of cross-sectional study 
N <- (nrow(xs))

# calculate current size of each education group
noqual_N <- nrow(filter(xs, pedcat == 0)) 
somesec_N <-  nrow(filter(xs, pedcat == 1))
sec_N <- nrow(filter(xs, pedcat == 2))
univ_N <- nrow(filter(xs, pedcat == 3))

# based on current sample size, 
# calculate ideal size of each group in proportion to population 
# (proportions from Table 5 of manuscript)
ideal_noqual <- .127 * N
ideal_somesec <- .246 * N
ideal_sec <- .355 * N
ideal_univ <- .271 * N

# check N based on ideal group sizes 
sizecheck <- ideal_noqual + ideal_somesec + ideal_sec + ideal_univ

# assuming no further data will be collected,
# adjust size of each group relative to 
# size of smallest current group (noqual: n = 40)

# calculate adjustment values in relation to population
somesec_val <- somesec_N / ideal_noqual
sec_val <- sec_N / ideal_noqual
univ_val <- univ_N / ideal_noqual

# calculate adjusted cell sizes
adj_somesec <- somesec_val * noqual_N
adj_sec <- sec_val * noqual_N
adj_univ <- univ_val * noqual_N

# calculate adjusted total sample size
adj_N <- noqual_N + adj_somesec + adj_sec + adj_univ

# calculate reduction of ideal sample from current sample
reduced_N <- round(1 - (adj_N / N), 2)

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
rm(sec_val)
rm(somesec_val)
rm(univ_val)
rm(sizecheck)
rm(reduced_N)
rm(somesec)
rm(noqual_N)
rm(sec_N)
rm(somesec_N)
rm(univ_N)
