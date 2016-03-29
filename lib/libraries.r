library(knitr)
library(ggplot2)
library(ggthemes)
require(dplyr)
require(rvest)
require(gsubfn)
require(zoo)
library(maptools)
library(sp)
library(digest)
library(ggplot2)
library(dplyr)
library(MASS)
library(mgcv)
library(extrafont)

# Uvozimo funkcije za delo z datotekami XML.
source("lib/xml.r", encoding = "UTF-8")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")


