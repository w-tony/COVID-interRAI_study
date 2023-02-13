# Define front-end ----
shinydashboard::dashboardPage(
  title = "Exploring the impact of COVID-19 on the aged residential care community using interRAI data",
  
  # Define header ----
  shinydashboard::dashboardHeader(
    title = "COVID-interRAI Explorer",
    titleWidth = 300
    ),
  
  # Define sidebar: DISABLED  ----
  shinydashboard::dashboardSidebar(
    disable = TRUE
    ),
  
  # Define body ----
  shinydashboard::dashboardBody(
    fluidRow(column(width = 6, 
                    tabBox(title = "Pre-COVID Era",
                           width = NULL, 
                           # Enter output here
                           tabPanel("Model summary"),
                           tabPanel("Plots")
                           )
                    ),
             column(width = 6,
                    tabBox(title = "Omicron period",
                        width = NULL, 
                        # Enter output here
                        tabPanel("Model summary"),
                        tabPanel("Plots")
                        )
                    )
             ),
    fluidRow(column(width = 6,
                    box(width = NULL,
                        selectInput("precovidOutcomeInput", "Outcome variable:", names(precovid.df[response_vars])),
                        selectInput("precovidExplanatoryInput", "Explanatory variable(s):", names(precovid.df[explanatory_vars]),
                                    multiple = TRUE)
                        )
                    ),
             column(width = 6,
                    box(width = NULL,
                        selectInput("omicronOutcomeInput", "Outcome variable:", names(omicron.df[response_vars])),
                        selectInput("omicronExplanatoryInput", "Explanatory variable(s):", names(omicron.df[explanatory_vars]),
                                    multiple = TRUE)
                        )
                    )
             )
    )
  )
