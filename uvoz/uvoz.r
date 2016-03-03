# 2. faza: Uvoz podatkov


##Uvozim tabelo, ki prikazuje umrle po starosti, spolu in po letih 2010-2014:

stolpci = c("Starost","Spol","Leto","Umrli")
umrli.starost <- read.csv2(file="podatki/umrli_starost.csv", col.names=stolpci, encoding ="UTF-8")

#poskrbim, da je spol tipa character
umrli.starost[,2] <- as.character(umrli.starost[,2])



#Naredim novo tabelo, v kateri glede na spol in leto prikažem število umrlih, povprečno starost umrlih,
#koliko od umrlih je umrlo mlajših od 65 lel ter njihov delež (prezgodnja umrljivost):

umrljivost <- data.frame(umrli.starost %>% group_by(Leto, Spol) 
                   %>% summarise(St.Umrlih = sum(Umrli), 
                                 Povprecna.starost = round(sum(c(0:100)*Umrli)/sum(Umrli,na.rm=TRUE),2),
                                 Mlajsi.od.65.let = sum(Umrli[1:65], 2, na.rm=TRUE),
                                 Prezgodnja.umrlivost = round((Mlajsi.od.65.let/St.Umrlih)*100,2)))




##uvozim tabelo, ki prikazuje število smrti po spolu, regijah, vzroku smrti ter letih

imena2 <- c("Spol","Regija","Leto","Vzrok","Število umrlih")
umrli.vzrok <- read.csv2(file= "podatki/vzrok_smrti.csv",col.names=imena2, encoding="UTF-8")


#spremenim vrste bolezni tako, da bodo samo besede, brez številčih oznak:
umrli.vzrok[,4] <- as.character(umrli.vzrok[,4])
umrli.vzrok$Vzrok <- umrli.vzrok$Vzrok %>% strapplyc("^([^(]*) \\(") %>% unlist() %>% factor()


#naredim tabelo, kjer je prikazano št. smrti glede na regijo in bolezen:
Umrli_vzroki_regije <- data.frame(umrli.vzrok %>% group_by(Regija,Vzrok) 
                           %>% summarise(Umrli = sum(Število.umrlih)))






##Uvozim novo tabelo, da bom lahko primerjala št. smrti v posamezni regiji glede na število prebivalcev:

stolpci0 <- c("Spol", "Regija", "Starost","Polletje" ,"St.Prebivalcev")
prebivalci <- read.csv2(file = "podatki/stevilo_prebivalcev.csv", skip=2, 
                        nrow=(292-2), header=FALSE, strip.white=TRUE, col.names=stolpci0,
                        fileEncoding="cp1250")

#Zbrišem stolpec starost, ki je nepotreben:
prebivalci$Starost <- NULL

#Uredim prazne prostore z NA ter jih zapolnim z vrednostmi, ki jim pripadajo:
for (i in stolpci0[c(-3,-5)]) {
  prebivalci[[i]][prebivalci[i] == " "] <- NA
  prebivalci[[i]] <- na.locf(prebivalci[[i]])
}


#Zbrišem odvečne vrstice(vse, ki so NA v "St.Prebivalcev"):
prebivalci <- prebivalci[!is.na(prebivalci$St.Prebivalcev),]
prebivalci$Polletje <- as.character(prebivalci$Polletje)




































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





