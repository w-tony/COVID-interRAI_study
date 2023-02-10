library(shiny)
library(shinydashboard)

# Define front-end ----
shinydashboard::dashboardPage(
  title = "Exploring the impact of COVID-19 on the aged residential care community using interRAI data",
  
  # Define header ----
  shinydashboard::dashboardHeader(
    title = "COVID-interRAI explorer",
    titleWidth = 300
    ),
  
  # Define sidebar: DISABLED  ----
  shinydashboard::dashboardSidebar(
    disable = TRUE
    ),
  
  # Define body ----
  shinydashboard::dashboardBody(
    fluidRow(column(width = 6, 
                    box(title = "Pre-COVID Era",
                        width = NULL, 
                        solidHeader = TRUE, 
                        status = "success"
                        )
                    ),
             column(width = 6,
                    box(title = "COVID period",
                        width = NULL, 
                        solidHeader = TRUE, 
                        status = "warning"
                        )
                    )
             ),
    fluidRow(column(width = 8,
                    mainPanel()
                    ),
             column(width = 4,
                    sidebarPanel()
                    )
             )
    )
  )
