# 2. faza: Uvoz podatkov

##Uvozim tabelo, ki prikazuje umrle po starosti, spolu in po letih 2010-2014:

stolpci = c("Starost","Spol","Leto","Umrli")
umrli.starost <- read.csv2(file="podatki/umrli_starost.csv", col.names=stolpci, fileEncoding="cp1250")

#poskrbim, da je spol tipa character ter uporabim kodo UTF-8 za prikaz šumnikov
umrli.starost[,2] <- as.character(umrli.starost[,2])
Encoding(umrli.starost[[2]])<-"UTF-8"


#Funkcija, ki mi za vsako leto in spol izračuna št. vseh umrlih:

stevilo.umrlih <- function(leto, spol){
  podatki <- filter(umrli.starost, Spol == spol, Leto == leto)
  sum(podatki$Umrli, na.rm=TRUE)
}

#Funkcija, ki mi za leto in spol izračuna povprečno starost umrlih:

povprecna.starost <- function(leto, spol){
  podatki <- filter(umrli.starost, Spol == spol, Leto == leto)
  round(sum(c(0:100)*podatki$Umrli)/sum(podatki$Umrli,na.rm=TRUE),2)
}


#Naredim funkcijo, ki mi za vsako leto izračuna št. umrlih mlajših od 65 let ter njihov delež (prezgodnja umrljivost)

mlajsi.od.65 <- function(leto,spol){
  podatki <- filter(umrli.starost, Spol == spol, Leto == leto)
  sum(podatki[1:65,4], 2, na.rm=TRUE)
}

prezgodnja.umrljivost <- function(leto,spol){
  round((mlajsi.od.65(leto,spol)/stevilo.umrlih(leto,spol))*100,2)
}
  
#Naredim vektorje za novo tabelo:

Umrli <- c(stevilo.umrlih(2010, "Moški"),stevilo.umrlih(2011, "Moški"),stevilo.umrlih(2012, "Moški"),stevilo.umrlih(2013, "Moški"),stevilo.umrlih(2014, "Moški"),
                 stevilo.umrlih(2010, "Ženske"),stevilo.umrlih(2011, "Ženske"),stevilo.umrlih(2012, "Ženske"),stevilo.umrlih(2013, "Ženske"),stevilo.umrlih(2014, "Ženske"))

Povprecje <- c(povprecna.starost(2010, "Moški"),povprecna.starost(2011, "Moški"),povprecna.starost(2012, "Moški"),povprecna.starost(2013, "Moški"),povprecna.starost(2014, "Moški"),
               povprecna.starost(2010, "Ženske"),povprecna.starost(2011, "Ženske"),povprecna.starost(2012, "Ženske"),povprecna.starost(2013, "Ženske"),povprecna.starost(2014, "Ženske"))

Mlajsi.od.65.let <- c(mlajsi.od.65(2010, "Moški"),mlajsi.od.65(2011, "Moški"),mlajsi.od.65(2012, "Moški"),mlajsi.od.65(2013, "Moški"),mlajsi.od.65(2014, "Moški"),
                      mlajsi.od.65(2010, "Ženske"),mlajsi.od.65(2011, "Ženske"),mlajsi.od.65(2012, "Ženske"),mlajsi.od.65(2013, "Ženske"),mlajsi.od.65(2014, "Ženske"))

Prezgodnja.umrljivost <- c(prezgodnja.umrljivost(2010, "Moški"),prezgodnja.umrljivost(2011, "Moški"),prezgodnja.umrljivost(2012, "Moški"),prezgodnja.umrljivost(2013, "Moški"),prezgodnja.umrljivost(2014, "Moški"),
                           prezgodnja.umrljivost(2010, "Ženske"),prezgodnja.umrljivost(2011, "Ženske"),prezgodnja.umrljivost(2012, "Ženske"),prezgodnja.umrljivost(2013, "Ženske"),prezgodnja.umrljivost(2014, "Ženske"))

Leto <- c(2010,2011,2012,2013,2014)
Spol <- c(rep("Moški", 5),rep("Ženske", 5))

umrljivost <- data.frame(Leto,Spol,Umrli,Povprecje,Mlajsi.od.65.let,Prezgodnja.umrljivost)
umrljivost[,2] <- as.character(umrljivost[,2])






#uvozim tabelo, ki prikazuje število smrti po spolu, regijah, vzroku smrti ter letih

imena2 <- c("Spol","Regija","Leto","Vzrok","Število umrlih")
umrli.vzrok <- read.csv2(file= "podatki/vzrok_smrti.csv",col.names=imena2, fileEncoding="cp1250")

#Poskrbimo, da so spol,občine in vzroki tipa character, ter uporabimo kodo UTF-8, da bodo prikazani šumniki

umrli.vzrok[,1:2] <- apply(umrli.vzrok[,1:2], 2, . %>% as.character())
umrli.vzrok[,4] <- as.character(umrli.vzrok[,4]) 
Encoding(umrli.vzrok[[1]])<-"UTF-8"
Encoding(umrli.vzrok[[2]])<-"UTF-8"
Encoding(umrli.vzrok[[4]])<-"UTF-8"



Vzroki <- c("Neoplazme","Bolezni obtočil","Bolezni dihal","Bolezni prebavil","Poškodbe, zastrupitve in zunanji vzroki")


stevilo_vzroki <- function(vzrok){
  podatki <- filter(umrli.vzrok, Vzrok == vzrok)
  sum(podatki$Število.umrlih, na.rm=TRUE)
}


stevilo.vzrok = c(stevilo_vzroki("Neoplazme (C00-D48)"), stevilo_vzroki("Bolezni obtočil (I00-I99)"),
                  stevilo_vzroki("Bolezni dihal (J00-J99)"), stevilo_vzroki("Bolezni prebavil (K00-K93)"),
                  stevilo_vzroki("Poškodbe, zastrupitve in nekatere druge posledice zunanjih vzrokov (S00-T98)"))


Bolezni <- data.frame(Vzroki, Umrli = stevilo.vzrok)





##Uvoz podatkov iz članka na spletni strani stat.si

link <- "http://www.stat.si/StatWeb/glavnanavigacija/podatki/prikazistaronovico?IdNovice=4013"

stran <- html_session(link) %>% read_html(encoding = "UTF-8")
tabele <- stran %>% html_nodes(xpath ="//table[@rules='all']")
tabela1 <- tabele %>% .[[1]] %>% html_table() 
tabela2 <- tabele %>% . [[2]] %>% html_table()

names(tabela1)<- tabela1[1,]
tabela1 = tabela1[-1,]
tabela1 = tabela1[-9,]
tabela1 = tabela1[-11,]
Encoding(tabela1[[1]]) <- "UTF-8"
tabela1[9,1] <- 'Povprečna starost umrlih - moški'
tabela1[10,1] <- 'Povprečna starost umrlih - ženske'
tabela1[11,1] <- 'Pričakovano trajanje življenja - moški'
tabela1[12,1] <- 'Pričakovano trajanje življenja - ženske'
names(tabela2)<- tabela2[1,]
tabela2 = tabela2[-1,]
Encoding(tabela2[[1]]) <- "UTF-8"

tabela2[,2:5] <- apply(tabela2[,2:5], 2, . %>% gsub("\\.", "", .) %>%
                                               gsub(",", ".", .) %>%
                                               as.numeric())
tabela1[,2:5] <- apply(tabela1[,2:5], 2, . %>% gsub("\\.", "", .) %>%
                                               gsub(",", ".", .) %>%
                                               as.numeric())





