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
                                       uiOutput("guess.UI"),
                                       fluidRow(
                                         column(6, align = "center", numericInput("ability.lower", "Lower Ability Limit", value = -4)),
                                         column(6, align = "center", numericInput("ability.upper", "Upper Ability Limit", value = 4))
                                       ),
                                       fluidRow(
                                         column(8, align = "center", offset = 2, actionButton("plot.it", "Generate ICC"))
                                       )),
                          mainPanel(withSpinner(plotlyOutput('iccplot')))))
