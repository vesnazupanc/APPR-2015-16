# 2. faza: Uvoz podatkov
source("lib/libraries.r", encoding = "UTF-8")



##Uvozim tabelo, ki prikazuje umrle po starosti, spolu in po letih 2010-2014:

stolpci = c("Starost","Spol","Leto","Umrli")
umrli.starost <- read.csv2(file="podatki/umrli_starost.csv", col.names=stolpci, encoding ="UTF-8")

#poskrbim, da je spol tipa character
umrli.starost[,2] <- as.character(umrli.starost[,2])
#Starost naj bo številska spremenljivka
umrli.starost$Starost <- as.character(umrli.starost$Starost)
umrli.starost$Starost <- umrli.starost$Starost %>% strapplyc("^([0-9]+)") %>% unlist() %>% as.numeric()
umrli.starost$Starost <- as.numeric(umrli.starost$Starost)


#Naredim novo tabelo, v kateri glede na spol in leto prikažem število umrlih, povprečno starost umrlih,
#koliko od umrlih je umrlo mlajših od 65 lel ter njihov delež (prezgodnja umrljivost):

umrljivost <- data.frame(umrli.starost %>% group_by(Leto, Spol) 
                   %>% summarise(St.Umrlih = sum(Umrli), 
                                 Povprecna.starost = round(sum(c(0:100)*Umrli)/sum(Umrli,na.rm=TRUE),2),
                                 Mlajsi.od.65.let = sum(Umrli[1:65], 2, na.rm=TRUE),
                                 Prezgodnja.umrljivost = round((Mlajsi.od.65.let/St.Umrlih)*100,2)))




##uvozim tabelo, ki prikazuje število smrti po spolu, regijah, vzroku smrti ter letih

imena2 <- c("Spol","Regija","Leto","Vzrok","Število umrlih")
umrli.vzrok <- read.csv2(file= "podatki/vzrok_smrti.csv",col.names=imena2, encoding="UTF-8")


#spremenim vrste bolezni tako, da bodo samo besede, brez številčih oznak:
umrli.vzrok[,4] <- as.character(umrli.vzrok[,4])
umrli.vzrok$Vzrok <- umrli.vzrok$Vzrok %>% strapplyc("^([^(]*) \\(") %>% unlist() %>% factor()



#še eno, ki prikazuje št. smrti v regiji glede na posamezno leto:
Umrli_regije <- data.frame(umrli.vzrok %>% group_by(Regija, Leto) 
                                  %>% summarise(Umrli = sum(Število.umrlih)))





##Uvozim novo tabelo, da bom lahko primerjala št. smrti v posamezni regiji glede na število prebivalcev:

stolpci0 <- c("Spol", "Regija", "Starost","Leto" ,"St.Prebivalcev")
prebivalci <- read.csv2(file = "podatki/stevilo_prebivalcev.csv", skip=2, 
                        nrow=(2798-2), header=FALSE, strip.white=TRUE, col.names=stolpci0,
                        fileEncoding="cp1250")



#Uredim prazne prostore z NA ter jih zapolnim z vrednostmi, ki jim pripadajo:
for (i in stolpci0[c(-5)]) {
  prebivalci[[i]][prebivalci[i] == " "] <- NA
  prebivalci[[i]] <- na.locf(prebivalci[[i]], na.rm = FALSE)
}


#Zbrišem odvečne vrstice(vse, ki so NA v "St.Prebivalcev"):
prebivalci <- prebivalci[!is.na(prebivalci$St.Prebivalcev),]




#Naredim tabelo, ki prikazuje št. prebivalcev v posamezni regiji glede na leto:

Prebivalci_regije <- data.frame(prebivalci %>% group_by(Regija,Leto) 
                                %>% summarise(St.Prebivalcev = sum(St.Prebivalcev)))




#Spremenim regije v starejše poimenovanje regij, saj imam vse ostale podatke še z prejšnimi imeni za regije:
Prebivalci_regije$Regija <- as.character(Prebivalci_regije$Regija)
Prebivalci_regije$Regija <- Prebivalci_regije$Regija %>% gsub("Posavska","Spodnjeposavska",.) 
Prebivalci_regije$Regija <- Prebivalci_regije$Regija %>% gsub("Primorsko-notranjska","Notranjsko-kraška",.)
Prebivalci_regije$Regija <- as.factor(Prebivalci_regije$Regija)



## sedaj združim tabeli Umrli_regije ter Prebivalci_regije:

Umrli_stopnje <- inner_join(Prebivalci_regije, Umrli_regije)


## Izračunam GROBO STOPNJO UMRLJIVOSTI   Groba stopnja umrljivosti je razmerje med 
#številom umrlih v koledarskem letu in številom prebivalcev v istem letu, pomnoženo s 100.000: 
Umrli_stopnje$Groba.stopnja.umrljivosti <- (Umrli_stopnje
                                                  %>% group_by(Regija,Leto)
                                                  %>% summarise(Groba.stopnja.umrljivosti = (Umrli/St.Prebivalcev)*100000))[[3]]


#Dodam urejenostno spremenljivko, ki pove ali je v posamezni regiji in letu stopnja umrljivosti visoka, normalna ali nizka.
#Za kriterij bom vzela: pod 1000-nizka, 1000:1600-normalna, nad 1600-visoka


Visina.stopnje <- rep('normalna', length(Umrli_stopnje$Groba.stopnja.umrljivosti))
Stopnja <- factor(Visina.stopnje,levels = c('nizka', 'normalna', 'visoka'),ordered = TRUE)
Stopnja[Umrli_stopnje$Groba.stopnja.umrljivosti <= 1000] <- 'nizka'
Stopnja[Umrli_stopnje$Groba.stopnja.umrljivosti >= 1600] <- 'visoka'
Umrli_stopnje$Stopnja <- Stopnja



### UVOZ NOVE TABELE ZA ANALIZO PROCENTA UMRLIH GLEDE NA STAROST:
stolpci1 <- c("Starost", "Spol", "Leto" ,"St.Prebivalcev")
prebivalci2 <- read.csv2(file = "podatki/prebivalci_starost.csv", skip=2, 
                         nrow=(1517-2), header=FALSE, strip.white=TRUE, col.names=stolpci1,
                         fileEncoding="cp1250")



#Uredim prazne prostore z NA ter jih zapolnim z vrednostmi, ki jim pripadajo:
for (i in stolpci1[c(-4)]) {
  prebivalci2[[i]][prebivalci2[i] == " "] <- NA
  prebivalci2[[i]] <- na.locf(prebivalci2[[i]], na.rm = FALSE)
}


#Zbrišem odvečne vrstice(vse, ki so NA v "St.Prebivalcev"):
prebivalci2 <- prebivalci2[!is.na(prebivalci2$St.Prebivalcev),]

#Starost spremenim v številski zapis:
prebivalci2$Starost <- as.character(prebivalci2$Starost)
prebivalci2$Starost <- prebivalci2$Starost %>% strapplyc("^([0-9]+)") %>% unlist() %>% as.numeric()

#Leto spremenim v številski zapis:
prebivalci2$Leto <- as.character(prebivalci2$Leto)
prebivalci2$Leto <- prebivalci2$Leto %>% strapplyc("^([0-9]+)") %>% unlist() %>% as.numeric()

#Naredim novo tabelo, ki jo bom potrebovala za analizo umrlih glede na starost:
TABELA3 <- inner_join(prebivalci2,umrli.starost)

TABELA3 <- (TABELA3 %>% group_by(Starost) %>%
              summarise(Umrli= sum(Umrli), St.Prebivalcev = sum(St.Prebivalcev)))

TABELA3$Procent.umrlih <- (group_by(TABELA3, Starost) %>% summarise(Umrli.procent = (Umrli/St.Prebivalcev)*100))[[2]] %>% round(2)

















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





