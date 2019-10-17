library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)
library(kableExtra)
library(reshape2)
library(shinycssloaders)

fluidPage(theme = shinytheme("darkly"),
          withMathJax(),
          pageWithSidebar(headerPanel("Item Characteristic Curve"),
                          sidebarPanel(selectInput('itemModel', 'Choose Item Parameter Model', c("Rasch (1PL)" = "1PL", 
                                                                                                 "Two Parameter Logistic (2PL)" = "2PL", 
                                                                                                 "Three Parameter Logistic (3PL)" = "3PL")),
                                       uiOutput("diff.UI"),
                                       uiOutput("disc.UI"),
                                       uiOutput("guess.UI")),
                          mainPanel(withSpinner(plotlyOutput('iccplot')))))
