# 2. faza: Uvoz podatkov


#umrli po občinah v letu 2014

stolpci = c("Občina", "Umrli", "Umrli mlajši od 65 let", "Prezgonja umrljivost")
uvozi.obcine <- function(){
  read.csv2(file= "podatki/podatki-obcine.csv", skip=4, nrow=(216-5), col.names=stolpci, fileEncoding="cp1250")
}

umrli.obcine <- uvozi.obcine()




#umrli po starostnih skupinah

leta = c("","starost", 2004:2014)
umrli.starost <- read.csv2(file = "podatki/umrli-starost.csv", skip = 4, nrow=(23-4),
                           header = FALSE, col.names = leta, fileEncoding= "cp1250")
umrli.starost <- umrli.starost[-1]

#umrli po vzrokih, 2004-2014

leta2 = c("vzrok",2004:2014)
umrli.vzrok <- read.csv2(file = "podatki/vzrok-2004-2014.csv", skip = 2, nrow=(23-3), col.names = leta2, fileEncoding= "cp1250")




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





