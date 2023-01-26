library(shiny)
library(shinydashboard)
library(plotly)
library(timevis)
library(shinyBS)

# Read interRAI data csv file
interRAI.df <- read_csv("interRAI_final.csv")

# Define header ----
header <- dashboardHeader(
  title = "COVID-interRAI Explorer",
  titleWidth = 350
  )

# Sidebar items ----
sidebar <- dashboardSidebar(
  width = 350,
  sidebarMenu(
    menuItem(
      text = "DATE RANGE",
      tabName = "date_range",
      icon = icon("calendar"),
      dateRangeInput(
        inputId = "dateSelectPrecovid", 
        label = "Pre-COVID era", 
        start = "2018-08-17", 
        end = "2020-02-27",
        min = "1997-09-01",
        max = "2020-02-27",
        width = "100%"
        ),
      bsTooltip(
        id = "dateSelectPrecovid",
        title = "This date range input is for the pre-COVID era before the first 
        case on 28 February 2020 and goes back to 1 September 1997.",
        placement = "right"),
      dateRangeInput(
        inputId = "dateSelectOmicron",
        label = "COVID period",
        start = "2021-12-16",
        end = "2022-08-17",
        min = "2020-02-28", 
        max = "2022-08-31",
        width = "100%"
        ),
      bsTooltip(
        id = "dateSelectOmicron",
        title = "This date range input is for the COVID era timeline and will track 
        information starting from 28 February 2020 to 31 August 2022.",
        placement = "right"
        )
      )
    )
  )

# Body content  ----
body <- dashboardBody(
  fluidRow(
    box(
      title = "Pre-COVID era",
      status = "primary",
      width = 6,
      height = 400,
      dataTableOutput("precovid_table")
      ),
    box(
      title = "COVID period",
      status = "primary",
      width = 6,
      height = 400,
      dataTableOutput("covid_table")
      )
    )
  )

# Compile the front-end as the UI ----
dashboardPage(header, sidebar, body)