# 2. faza: Uvoz podatkov
require(dplyr)
require(rvest)
require(gsubfn)


#umrli po občinah v letu 2014

stolpci = c("Občina", "Umrli", "Umrli mlajši od 65 let", "Prezgonja umrljivost")
uvozi.obcine <- function(){
  read.csv2(file= "podatki/podatki-obcine.csv", skip=4, nrow=(216-5), col.names=stolpci, fileEncoding="cp1250")
}

umrli.obcine <- uvozi.obcine()
write.csv(umrli.obcine,"umrli.obcine.csv",row.names=FALSE)




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


write.csv(tabela1,"tabela1.csv",row.names=FALSE)
write.csv(tabela2,"tabela2.csv",row.names=FALSE)


