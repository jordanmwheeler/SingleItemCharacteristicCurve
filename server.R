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
  
  output$iccplot <- renderPlotly({
    alpha = input$diff.param
    beta = ifelse(is.null(input$disc.param), 1, input$disc.param)
    guess = ifelse(is.null(input$guess.param), 0, input$guess.param)
    thetas = seq(-4, 4, .1)
    guess_vec = rep(guess, length(thetas))
    ps = round(guess+((1-guess)*(1/(1+exp(-alpha*(thetas-beta))))), 4)
    dat = data.frame(cbind(thetas, ps, guess_vec))
    
    dat %>%
    plot_ly(x = ~thetas, y = ~ps, mode = 'lines',
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

}
