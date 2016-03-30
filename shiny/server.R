library(shiny)

if ("server.R" %in% dir()) {
  setwd("..")
}
source("lib/libraries.r", encoding = "UTF-8")
source("uvoz/uvoz.r", encoding = "UTF-8")
source("vizualizacija/vizualizacija.r", encoding = "UTF-8")
source("analiza/analiza.r", encoding = "UTF-8")

shinyServer(function(input, output) {
  
  output$starost <- DT::renderDataTable({
    t <- data.frame(TABELA3)
    colnames(t) <- c("a", "Umrli", "Prebivalci", "Procent Umrlih")
    row.names(t) <- t[[1]]
    t <- t[,-1]
    t
  })
  
  output$stopnja <- renderUI(
    selectInput("stopnja", label="Izberi stopnjo umrljivosti",
                choices=c("Vse", levels(Umrli_stopnje$Stopnja)))
    )
  
  output$zemljevid<-renderPlot({
    ggplot() + geom_polygon(data = Umrli_stopnje %>%
                              filter(Leto == 2014) %>%
                              group_by(Regija, Stopnja) %>%
                              filter(Stopnja == input$var) %>%
                              right_join(SLO, by = c("Regija" = "NAME_1")),
                            aes(x = long, y = lat, group = group,
                                fill = Stopnja), color = "grey") +
      scale_fill_manual(values = c("nizka" = "green",
                                   "normalna" = "orange",
                                   "visoka" = "red")) +
      geom_text(data = SLO %>% group_by(id, NAME_1) %>% summarise(x = mean(long), y = mean(lat)),
                aes(x = x, y = y, label = NAME_1), size = 2.5)
    })
})





      