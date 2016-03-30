library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Umrljivost v Sloveniji"),

  tabsetPanel(
    
    tabPanel("Predstavitev",
      sidebarPanel(
        h3("Kdo sem?"),
        p("Sem", strong("Vesna Zupanc"), "študentka 2.letnika Finančne matematike."),
        br(),
        h3("Kontaktni podatki:"),
        p(strong("e-mail:"),"vesna.zupanc@student.fmf.uni-lj.si")
        ),
        
        mainPanel(
          h1("Uvod"),
          p("V sklopu projetka pri predmetu", em("Analiza podatkov s programom R"), 
            "sem zgradila aplikacijo Shiny, v kateri sem prikazala več povezav, ugotovitev in izračunov, pridobljenih v okviru projekta."),
          br(),
          h2("Projekt"),
          p("Za temo projekta sem si izbrala", strong("Analizo smrti v Sloveniji"),". S programom R pa sem:"),
          p("* uvozila podatke v obliki CSV in HTML,"),
          p("* poskrbela, da so podatki v obliki", em("tidy data,")),
          p("* naredila vizualizacijo podatkov, kjer sem narisala več grafov in zemljevid,"),
          p("* analizirala povezanost med podatki, ter poskušala napovedati prihodnjo povprečno starost umrlih.")
          )),
    
    tabPanel("Podatki po starosti",
             mainPanel(
               DT::dataTableOutput("starost")),
             sidebarPanel(h3("Tabela po starosti"),
                          p("Prikazana tabela za vsako starost (od 0 do 100let) prikazuje:"),
                          p("* število umrlih,"),
                          p("* število prebivalcev"),
                          p("* precent umrlih, glede na število prebivalcev."),
                          br(),
                          p("Če želite pogledati kakšno točno število, lahko vpišete to število v polje", strong("search"),
                            " in kliknete enter"))
             ),
            
    
    tabPanel("Stopnja umrljivosti po regijah",
             
             sidebarPanel(h3("Zemljevid stopenj umrljivosti"),
                          p("Na zemljevidu so prikazane stopnje umrljivosti, glede na posamezno leto."),
                          p("Formula, po kateri se izračuna (groba) stopnja umrljivosti je:"),
                          p("Y = Umrli/St.Prebivalcev)*100000,", align = "center"),
                          p("stopnje umrljivosti pa so rangirane po naslednjem kriteriju:"),
                          p("* ",em("nizka"), " <-> ", "Y <= 1000"),
                          p("* ",em("normalna"), " <-> ", " 1000 < Y < 1600"),
                          p("* ",em("nizka"), " <-> ", "Y > 1600")),
             
             sidebarPanel(
                selectInput("stopnja", 
                            label="Izberi stopnjo umrljivosti",
                            choices=c("Vse", levels(Umrli_stopnje$Stopnja))),
               selectInput("leto", 
                           label="Izberi leto",
                           choices=c(2010:2014))),
             
             mainPanel(plotOutput("zemljevid"))
             
             ),
    
    tabPanel("Prezgodnja umrljivost",
             
             sidebarPanel(h3("Graf prezgodnje umrljivosti"),
                          p("Slednji graf prikazuje prezgodnjo umrljivost, 
                            ter njeno naraščanje ali padanje po letih (od 2010 do 2014)."),
                          p("Prezgodnja umrljivost je pravzaprav delež umrlih mlajših od 65 let, glede na vse umrle."),
                          br(),
                          p("Pogledate si lahko dve različni tabeli in sicer tako,
                            da izberete spol, za katerega vas zanima gibanje prezgodnje umrljivosti."),
                          width = 3),
             
             sidebarPanel(
               selectInput("spol", 
                           label="Izberi spol",
                           choices=c("Moški", "Ženske"))),
             
             mainPanel(plotOutput("prezgodnja"))),
    
    tabPanel("Vzrok smrti",
             
             sidebarPanel(h3("Graf po vzrokih smrti"),
                          p("Naslednji graf prikazuje število smrti v posameznem letu, glede na spol in vzrok smrti."),
                          p("Izberete si lahko spol in pa vzrok, za katerega vas zanima statistika."),
                          width = 12
                          
             ),
             
             sidebarPanel(
               selectInput("spol2", 
                           label="Izberi spol",
                           choices=c("Moški","Ženske")),
               selectInput("vzrok", 
                           label="Izberi vzrok smrti",
                           choices=levels(umrli.vzrok$Vzrok))),
             
             mainPanel(plotOutput("vzroki")))
    
)))
