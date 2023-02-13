# Load libraries  ----
library(shiny)
library(shinydashboard)
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

# Rename the columns
rename_columns = function(dataframe) {
  dataframe <- dataframe %>%
    rename("Ethnicity" = "Ethnicity_adjusted",
           "Marital status" = "Marital_group",
           "Self-rated health" = "self_rated_health",
           "ADL Hierarchy Scale" = "ADLHierarchy_3class",
           "Cognitive Performance Scale" = "CPS_3class",
           "Falls in the last 30 days" = "Falls_2class",
           "Depressive Rating Scale" = "DRS_3class",
           "Says or indicates that he/she feels lonely" = "loneliness")
  return(dataframe)
}
precovid.df <- rename_columns(precovid.df)
omicron.df <- rename_columns(omicron.df)

# Create a vector labelling the response variables
response_vars <- c("Self-rated health", "ADL Hierarchy Scale", "Cognitive Performance Scale",
                   "Falls in the last 30 days", "Depressive Rating Scale", "Says or indicates that he/she feels lonely")

# Create a vector of the possible explanatory variables
explanatory_vars <- c("Ethnicity", "Marital status")