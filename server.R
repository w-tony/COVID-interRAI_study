library(shiny)
source("helpers.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  # Fetch the dates that are selected from the precovid table
  output$dateRangeText <- renderText({
    paste(input$dateSelectPrecovid[2])
  })
})
