# 2. faza: Uvoz podatkov


##Uvozim tabelo, ki prikazuje umrle po starosti, spolu in po letih 2010-2014:

stolpci = c("Starost","Spol","Leto","Umrli")
umrli.starost <- read.csv2(file="podatki/umrli_starost.csv", col.names=stolpci, encoding ="UTF-8")

#poskrbim, da je spol tipa character
umrli.starost[,2] <- as.character(umrli.starost[,2])



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

M <- c(NA)
povpM <- c(NA)
mlajsiM <- c(NA)
prezgodnjaM <- c(NA)
Z <- c(NA)
povpZ <- c(NA)
mlajsiZ <- c(NA)
prezgodnjaZ <- c(NA)

j=1
for (i in c(2010:2014)){
  M[j] <- stevilo.umrlih(i, "Moški")
  povpM[j] <- povprecna.starost(i, "Moški")
  mlajsiM[j] <- mlajsi.od.65(i, "Moški")
  prezgodnjaM[j] <- prezgodnja.umrljivost(i, "Moški")
  
  Z[j] <- stevilo.umrlih(i, "Ženske")
  povpZ[j] <- povprecna.starost(i, "Ženske")
  mlajsiZ[j] <- mlajsi.od.65(i, "Ženske")
  prezgodnjaZ[j] <- prezgodnja.umrljivost(i, "Ženske")
  j <- j+1
}


Umrli <- c(M,Z)
Povprecje <- c(povpM, povpZ)
Mlajsi.od.65.let <- c(mlajsiM, mlajsiZ)
Prezgodnja.umrljivost <- c(prezgodnjaM,prezgodnjaZ)

Leto <- c(2010,2011,2012,2013,2014)
Spol <- c(rep("Moški", 5),rep("Ženske", 5))

umrljivost <- data.frame(Leto,Spol,Umrli,Povprecje,Mlajsi.od.65.let,Prezgodnja.umrljivost)
umrljivost[,2] <- as.character(umrljivost[,2])






##uvozim tabelo, ki prikazuje število smrti po spolu, regijah, vzroku smrti ter letih

imena2 <- c("Spol","Regija","Leto","Vzrok","Število umrlih")
umrli.vzrok <- read.csv2(file= "podatki/vzrok_smrti.csv",col.names=imena2, encoding="UTF-8")

#Poskrbimo, da so spol,občine in vzroki tipa character

umrli.vzrok[,1] <- as.character(umrli.vzrok[,1])
umrli.vzrok[,4] <- as.character(umrli.vzrok[,4])




Vzroki <- c("Neoplazme","Bolezni obtočil","Bolezni dihal","Bolezni prebavil","Poškodbe, zastrupitve in zunanji vzroki")
Original <- c("Neoplazme (C00-D48)", "Bolezni obtočil (I00-I99)", "Bolezni dihal (J00-J99)", 
              "Bolezni prebavil (K00-K93)", "Poškodbe, zastrupitve in nekatere druge posledice zunanjih vzrokov (S00-T98)")

  
stevilo.vzroki <- function(vzrok){
  podatki <- filter(umrli.vzrok, Vzrok == vzrok)
  sum(podatki$Število.umrlih, na.rm=TRUE)
}

Umrli <- c(NA)
j=1
for (i in Original){
  Umrli[j] <- stevilo.vzroki(i)
  j <- j+1
}

Bolezni <- data.frame(Vzroki, Umrli)


##NAREDIM TABELO - ŠTEVILO SMRTI PO REGIJAH v letih 2010-2014:
Regije <- umrli.vzrok["Regija"]
Regije <- Regije[-1,]
Regije <- c(levels(Regije))

umrli.regija <- function(regija){
  podatki <- filter(umrli.vzrok, Regija == regija)
  sum(podatki$Število.umrlih, na.rm=TRUE)
}

umrli.spol <- function(regija, spol){
  podatki <- filter(umrli.vzrok, Spol==spol, Regija==regija)
  sum(podatki$Število.umrlih, na.rm=TRUE)
}



Umrli <- c(NA)
Zenske <- c(NA)
Moski <- c(NA)

j <- 1
for (i in Regije){
  Umrli[j] <- umrli.regija(i)
  Zenske[j] <- umrli.spol(i, "Ženske")
  Moski[j] <- umrli.spol(i, "Moški")
  j <- j+1
  }


Umrli_regije <- data.frame(Regije, Umrli, Zenske, Moski)


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





