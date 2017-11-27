# ---------------------------
# KidsWords Project
# Data preparation-04
# Thomas Klee
# Created: 2017-11-27
# Updated: 
# ---------------------------

library(tidyverse)

# This script recodes 11 peduc categories into 4 summary categories and orders them.

# aggregate peduc codes (0-9) into a new variable (pedcat)
# using Statistics NZ categories and declare as an ordered factor:
# 0 = no qualification
# 1 = level 1-2 certificates (some secondary qualification)
# 2 = level 3-4 certificates and level 5-6 diplomas (secondary education certs and dips)
# 3 = level 7-10 undergrad and postgrad degrees and grad and postgrad 
# certs and dips (university degree)
# 11 = level 11 overseas secondary school qualification
CDIPQ$pedcat <- recode(CDIPQ$peduc,
                         '0' = "0",
                         '1' = "1",
                         '2' = "1",
                         '3' = "2",
                         '4' = "2",
                         '5' = "2",
                         '6' = "2",
                         '7' = "3",
                         '8' = "3",
                         '9' = "3",
                         '10' = "3",
                         '11' = "2"
)

CDIPQ$pedcat <- ordered(CDIPQ$pedcat)

CDIPQ$camos <- ordered(CDIPQ$camos)

# convert data frame to csv file
write_csv(CDIPQ, "data/data_CDIPQ.csv")

glimpse(CDIPQ)

summary(CDIPQ)
