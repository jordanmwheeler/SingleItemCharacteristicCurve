library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)
library(kableExtra)
library(reshape2)
library(shinycssloaders)


function(input, output, session){
  output$iccplot <- renderPlotly({
    plotly_empty()%>%
      layout(plot_bgcolor='#222222',
             paper_bgcolor='#222222')
  })
  output$diff.UI <- renderUI({
    switch(input$itemModel,
           "1PL" = numericInput("diff.param", "Difficulty Parameter:", value = 1),
           "2PL" = numericInput("diff.param", "Difficulty Parameter:", value = 1),
           "3PL" = numericInput("diff.param", "Difficulty Parameter:", value = 1))
  })
  output$disc.UI <- renderUI({
    switch(input$itemModel,
           "1PL" = return(),
           "2PL" = numericInput("disc.param", "Discrimination Parameter:", value = 1),
           "3PL" = numericInput("disc.param", "Discrimination Parameter:", value = 1))
  })
  output$guess.UI <- renderUI({
    switch(input$itemModel,
           "1PL" = return(),
           "2PL" = return(),
           "3PL" = sliderInput("guess.param", "Guessing Parameter:", min = 0, max = 1, value = .2))
  })
  
  observeEvent(input$plot.it, {
      if(input$itemModel == "1PL"){
        beta = input$diff.param
        alpha = ifelse(is.null(input$disc.param), 1, input$disc.param)
        guess = ifelse(is.null(input$guess.param), 0, input$guess.param)
        lower.lim = ifelse(is.null(input$ability.lower), -4, input$ability.lower)
        upper.lim = ifelse(is.null(input$ability.upper), 4, input$ability.upper)
        thetas = seq(lower.lim, upper.lim, .1)
        guess_vec = rep(guess, length(thetas))
        ps = round((1/(1+exp(-1*(thetas-beta)))), 4)
      }
      if(input$itemModel == "2PL"){
        beta = input$diff.param
        alpha = ifelse(is.null(input$disc.param), 1, input$disc.param)
        guess = ifelse(is.null(input$guess.param), 0, input$guess.param)
        lower.lim = ifelse(is.null(input$ability.lower), -4, input$ability.lower)
        upper.lim = ifelse(is.null(input$ability.upper), 4, input$ability.upper)
        thetas = seq(lower.lim, upper.lim, .1)
        guess_vec = rep(guess, length(thetas))
        ps = round((1/(1+exp(-alpha*(thetas-beta)))), 4)
      }
      if(input$itemModel == "3PL"){
        beta = input$diff.param
        alpha = ifelse(is.null(input$disc.param), 1, input$disc.param)
        guess = ifelse(is.null(input$guess.param), 0, input$guess.param)
        lower.lim = ifelse(is.null(input$ability.lower), -4, input$ability.lower)
        upper.lim = ifelse(is.null(input$ability.upper), 4, input$ability.upper)
        thetas = seq(lower.lim, upper.lim, .1)
        guess_vec = rep(guess, length(thetas))
        ps = round(guess+((1-guess)*(1/(1+exp(-alpha*(thetas-beta))))), 4)
      }
      dat = data.frame(cbind(thetas, ps, guess_vec))
      
      output$iccplot <- renderPlotly({
        plot_ly(dat, x = ~thetas, y = ~ps, mode = 'lines',
                text = ~paste0("Ability: ", thetas, "<br>Probability: ", ps)) %>%
          layout(title = "Logistic Item Characteristic Curve",
                 font = list(color = "#ffffff"),
                 xaxis = list(title = "Ability",
                              gridcolor = "rgba(179, 179, 179, .25)",
                              nticks = 6),
                 yaxis = list(title = "Probability of Answering Item Correct<br>",
                              gridcolor = "rgba(179, 179, 179, .25)",
                              tickformat='.3f',
                              range = c(0,1)),
                 plot_bgcolor = '#222222',
                 paper_bgcolor = '#222222')
    })
  })
}
