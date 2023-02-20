# Define User Interface ----
shinydashboard::dashboardPage(
  title = "Exploring the impact of COVID-19 on the aged residential care community using interRAI data",
  
  # Define header ----
  dashboardHeader(
    title = "COVID-interRAI Explorer",
    titleWidth = 300
    ),
  
  # Define sidebar: DISABLED  ----
  dashboardSidebar(
    disable = TRUE
    ),
  
  # Define body ----
  dashboardBody(
    fluidRow(column(width = 6, 
                    tabBox(title = "Pre-COVID Era",
                           width = NULL, 
                           # Enter output here
                           tabPanel("Model summary",
                                    withSpinner(verbatimTextOutput("precovidModel"))),
                           tabPanel("Plots")
                           )
                    ),
             column(width = 6,
                    tabBox(title = "Omicron period",
                        width = NULL, 
                        # Enter output here
                        tabPanel("Model summary",
                                 withSpinner(verbatimTextOutput("omicronModel"))),
                        tabPanel("Plots")
                        )
                    )
             ),
    fluidRow(column(width = 6,
                    box(width = NULL,
                        selectInput("precovidOutcomeInput", 
                                    "Outcome variable:", 
                                    setNames(names(precovid.df[response_vars]), names(response_vars))),
                        selectInput("precovidExplanatoryInput", 
                                    "Explanatory variable(s):", 
                                    setNames(names(precovid.df[explanatory_vars]), names(explanatory_vars)),
                                    selected = "Ethnicity_adjusted",
                                    multiple = TRUE)
                        )
                    ),
             column(width = 6,
                    box(width = NULL,
                        selectInput("omicronOutcomeInput", 
                                    "Outcome variable:", 
                                    setNames(names(omicron.df[response_vars]), names(response_vars))),
                        selectInput("omicronExplanatoryInput", 
                                    "Explanatory variable(s):", 
                                    setNames(names(omicron.df[explanatory_vars]), names(explanatory_vars)),
                                    selected = "Ethnicity_adjusted",
                                    multiple = TRUE)
                        )
                    )
             )
    )
  )
