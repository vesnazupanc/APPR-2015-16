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

Zemljevid.Umrli <- ggplot() + geom_polygon(data = umrli.vzrok  %>% 
                                             filter(Leto == 2014) %>%
                                             right_join(SLO, by = c("Regija" = "NAME_1")),
                                             aes(x = long, y = lat, group = group,
                                                 fill = Umrli)) + ggtitle("Umrli v sloveniji") 


print(Zemljevid.Umrli)
