library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Umrljivost v Sloveniji"),
  
  tabsetPanel(
    tabPanel("Podatki po starosti",
             DT::dataTableOutput("starost")),
    
    tabPanel("Stopnja umrljivosti po regijah",
             sidebarPanel(
               uiOutput("stopnja")
             ),
             mainPanel(plotOutput("zemljevid")))
  )
))
