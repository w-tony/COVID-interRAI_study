# Define Server logic ----
shinyServer(function(input, output, session) {
  
  # Gather the formula for the pre-COVID & Omicron models using the user-specified inputs
  precovid_formula <- reactive({
    as.formula(paste(input$precovidOutcomeInput, "~", paste(input$precovidExplanatoryInput, collapse="+")))
  })
  omicron_formula <- reactive({
    as.formula(paste(input$omicronOutcomeInput, "~", paste(input$omicronExplanatoryInput, collapse="+")))
  })
  
  # Fit the multinomial models using the "nnet" package
  precovid_multinom <- reactive({
    req(input$precovidExplanatoryInput)
    multinom(precovid_formula(), data=precovid.df)
  })
  omicron_multinom <- reactive({
    req(input$omicronExplanatoryInput)
    multinom(omicron_formula(), data=omicron.df)
  })
  
  # Render output items
  output$precovidModel <- renderPrint(summary(precovid_multinom()))
  output$omicronModel <- renderPrint(summary(omicron_multinom()))
})
