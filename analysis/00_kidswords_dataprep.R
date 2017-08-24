# ---------------------------
# KidsWords project
# Data preparation-00
# Thomas Klee
# Created: 23 Aug 2017
# Updated: 24 Aug 2017
# ---------------------------

# no need to upload this script to GitHub since it involves a hand-coded file
# that gets incorporated into 02_kidswords_dataprep.R

# This script exports selected variables from the PQ dataframe
# and saves them in a csv file to send to Liz Gibson so that she can finish
# coding the remaining parent education data.

# load tidyverse
library(tidyverse)

# select PQ variables needed for coding remaining parent education data
PQ_educ <- select(PQ, PID, psec_qual, pother_qual, pother_qual_what, peduc)

# convert dataframe to csv file
write_csv(PQ_educ, "data/KidsWords_peduc_20170824_for_EG.csv")

# when Liz sends back coded data file, the file should be renamed 
# data/KidsWords_peduc.csv, after which all of the dataprep
# scripts should be re-run.
