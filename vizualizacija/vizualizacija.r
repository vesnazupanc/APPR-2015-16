# 3. faza: Izdelava zemljevida

source("lib/uvozi.zemljevid.r", encoding = "UTF-8")
library(ggplot2)
library(dplyr)


# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                             "SVN_adm1", encoding = "UTF-8")


# Preuredimo podatke, da jih bomo lahko izrisali na zemljevid.

pretvori.zemljevid <- function(zemljevid) {
  fo <- fortify(zemljevid)
  data <- zemljevid@data
  data$id <- as.character(0:(nrow(data)-1))
  return(inner_join(fo, data, by="id"))
}


SLO <- pretvori.zemljevid(zemljevid)


##Naredim zemljevid, kjer prikažem stopnjo umrljivosti (zelena-nizka, rdeča-visoka)

Zemljevid.Umrli <- ggplot() + geom_polygon(data = Umrli_stopnje %>%
                                             right_join(SLO, by = c("Regija" = "NAME_1")),
                                           aes(x = long, y = lat, group = group, fill = Groba.stopnja.umrljivosti),
                                             color = "grey") +
                                             scale_fill_gradient(low = "#11FF00", high = "#FF0000")+
                                             guides(fill = guide_colorbar(title = "Stopnja")) +
                                             ggtitle("Groba stopnja umrljivosti v Sloveniji")

#Na zemljevid dodam imena regij

Zemljevid.Umrli <- Zemljevid.Umrli +
  geom_text(data = SLO %>% group_by(id, NAME_1) %>% summarise(x = mean(long), y = mean(lat)),
                            aes(x = x, y = y, label = NAME_1), size = 2.5)

#odstranim še oznake na x,y osi ter poimenovanje osi, ozadnje naredim belo

Zemljevid.Umrli <- Zemljevid.Umrli +
  labs(x="", y="")+
  scale_y_continuous(breaks=NULL)+
  scale_x_continuous(breaks=NULL)+
  theme_minimal()
  
  

  
  
