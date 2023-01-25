library(shiny)
library(shinydashboard)

header <- dashboardHeader(
  title = "COVID-interRAI Explorer",
  titleWidth = 400,
  dropdownMenu(
    
  )
)

sidebar <- dashboardSidebar()

body <- dashboardBody()

dashboardPage(header, sidebar, body)