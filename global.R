# Load libraries  ----
library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(nnet)
library(dplyr)

# Data processing ----

# Load the Precovid & Omicron data
precovid.df <- read.csv("Z:/precovid_final.csv")
omicron.df <- read.csv("Z:/omicron_final.csv")

# Re-organise the factors for self-rated health
precovid.df$self_rated_health <- factor(precovid.df$self_rated_health, levels=c("Excellent", "Good", "Fair", "Poor", "Could not (would not) respond"))
levels(precovid.df$self_rated_health) <- c("Excellent/good", "Excellent/good", "Fair", "Poor", "Could not (would not) respond")
omicron.df$self_rated_health <- factor(omicron.df$self_rated_health, levels=c("Excellent", "Good", "Fair", "Poor", "Could not (would not) respond"))
levels(omicron.df$self_rated_health) <- c("Excellent/good", "Excellent/good", "Fair", "Poor", "Could not (would not) respond")

# Create a vector labelling the response variables
response_vars <- c("self_rated_health", "ADLHierarchy_3class", "CPS_3class", "Falls_2class", 
                   "DRS_3class", "loneliness")
names(response_vars) <- c("Self-rated health", "ADL Hierarchy Scale", "Cognitive Performance Scale",
                          "Falls in the last 30 days", "Depressive Rating Scale", 
                          "Says or indicates that he/she feels lonely")

# Create a vector of the possible explanatory variables
explanatory_vars <- c("Ethnicity_adjusted", "Marital_group")
names(explanatory_vars) <- c("Ethnicity", "Marital status")