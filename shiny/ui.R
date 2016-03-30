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
             sidebarPanel(
               uiOutput("leto")
             ),
             mainPanel(plotOutput("zemljevid"))),
    
    tabPanel("Prezgodnja umrljivost",
             sidebarPanel(
               uiOutput("spol")
             ),
             
             mainPanel(plotOutput("prezgodnja"))),
    
    tabPanel("Vzrok smrti",
             sidebarPanel(
               uiOutput("spol")
             ),
             sidebarPanel(
               uiOutput("vzrok")
             ),
             mainPanel(plotOutput("vzroki")))
)))
