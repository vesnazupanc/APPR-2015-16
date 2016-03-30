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
  
  output$leto <- renderUI(
    selectInput("leto", label="Izberi leto",
                choices=c(2010:2014))
  )
  
  podatki1 <- Umrli_stopnje
  output$zemljevid<-renderPlot({
    if (length(input$stopnja) > 0 && input$stopnja %in% podatki1$Stopnja) {
      data <- podatki1 %>% filter(Stopnja == input$stopnja, Leto == input$leto)
    } else {
      data <- podatki1
    }
    ggplot() + geom_polygon(data = data %>%
                              right_join(SLO, by = c("Regija" = "NAME_1")),
                            aes(x = long, y = lat, group = group,
                                fill = Stopnja), color = "grey") +
      scale_fill_manual(values = c("nizka" = "green",
                                   "normalna" = "orange",
                                   "visoka" = "red")) +
      geom_text(data = SLO %>% group_by(id, NAME_1) %>% summarise(x = mean(long), y = mean(lat)),
                aes(x = x, y = y, label = NAME_1), size = 2.5)+
      labs(x="", y="")+
      scale_y_continuous(breaks=NULL)+
      scale_x_continuous(breaks=NULL)+
      theme_minimal()
  })
  
  output$spol <- renderUI(
    selectInput("spol", label="Izberi spol",
                choices=c("Moški", "Ženske"))
  )
  
  output$prezgodnja<-renderPlot({
    data <- umrljivost[c(-3,-4,-5)] %>% filter(Spol == input$spol)
    ggplot() + geom_line(data = data, aes(x=Leto, y=Prezgodnja.umrljivost)) +
      geom_point(data = data, aes(x=Leto, y=Prezgodnja.umrljivost), size=3) +
      labs(title ="Prezgodnja umrljivost")+
      theme_bw()

  })
  
  output$vzrok <- renderUI(
    selectInput("vzrok", label="Izberi vzrok smrti",
                choices=levels(umrli.vzrok$Vzrok))
  )
  
  output$vzroki<-renderPlot({
    data <- umrli.vzrok %>% group_by(Spol,Leto,Vzrok) %>% 
      summarise(Umrli = sum(Število.umrlih)) %>% 
      filter(Spol == input$spol, Vzrok == input$vzrok)
    ggplot() + geom_bar(data = data, aes(x=Leto, y=Umrli)) +
      labs(title ="Število umrlih glede na vzrok")+
      theme_bw()
    
  })
  
  
})





      