library(shiny)
library(ggplot2)



shinyUI(
  navbarPage("Coursera",
             tabPanel("Application",
  
  fluidPage(
  
  title = "Time Series Explorer",
  
  plotOutput('plot'),
  
  hr(),
  
  fluidRow(
    column(3,
           h4("Curve Parametres :"),
           sliderInput('pause','Step (en min.)', 
                       min=1, max=60,
                       value=5, 
                       step=5, round=0),
           br(),
           radioButtons('courbe', 'Courbe',c('Web'='Web','Call'='Call','Web & Call'='Web & Call'),'Web')
           
    )
    ,
    column(3,offset = 1,h4("Filtre Web Data :"),br(),
           selectInput('filterWeb1', 'Session',c("All","Question"),"All")
    )
    ,
    column(3,offset = 1,h4("Filtre Call Center Data :"),br(),
           selectInput('filterCall1', 'Service', c("All","Answered","Abandonned"),"All")
    )
  )
)),
tabPanel("Doc",
         verbatimTextOutput(h4("summary"))
)))