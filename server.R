# Define Server logic ----
shinyServer(function(input, output, session) {
  
  # Gather the formula for the pre-COVID & Omicron models using the user-specified inputs
  precovid_formula <- reactive({
    as.formula(paste(input$precovidOutcomeInput, "~", paste(input$precovidExplanatoryInput, collapse="+")))
  })
  precovid_formula_adjusted <- reactive({
    as.formula(paste(input$precovidOutcomeInput, "~", paste(c(input$precovidExplanatoryInput, "age", "gender_group"))))
  })
  omicron_formula <- reactive({
    as.formula(paste(input$omicronOutcomeInput, "~", paste(input$omicronExplanatoryInput, collapse="+")))
  })
  omicron_formula_adjusted <- reactive({
    as.formula(paste(input$omicronOutcomeInput, "~", paste(c(input$omicronExplanatoryInput, "age", "gender_group"))))
  })
  
  # Fit the multinomial models using the "nnet" package
  precovid_multinom <- reactive({
    multinom(precovid_formula(), data=precovid.df)
  })
  precovid_adjusted_multinom <- reactive({
    multinom(precovid_formula(), data=precovid.df)
  })
  omicron_multinom <- reactive({
    multinom(omicron_formula(), data=omicron.df)
  })
  omicron_adjusted_multinom <- reactive({
    multinom(omicron_adjusted_multinom(), data=omicron.df)
  })
  
  output$precovidModel <- renderPrint(summary(precovid_multinom()))
  output$omicronModel <- renderPrint(summary(omicron_multinom()))
})
