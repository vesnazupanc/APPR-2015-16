---
output: pdf_document
---
# Analiza smrti v Sloveniji

Avtor: Vesna Zupanc

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2015/16.

## Tematika

Analizirala bom umrljivost v Sloveniji. Podatke, ki jih bom pridobila bom analizirala po najpogostejših vzrokih za smrt, starosti ter številu smrti po regijah. 

Cilj moje analize je predvsem spoznati, kaj je najpogostejši vzrok smrti pri nas, kakšna je najpogostejša starost za smrt, kako se to s časom spremija (če se) ter kje v Sloveniji je najvišja stopnja umrljivosti. 

Podatki:

* (http://pxweb.stat.si/pxweb/Database/Dem_soc/05_prebivalstvo/32_Umrljivost/05_05L10_umrli_SL/05_05L10_umrli_SL.asp)
* (https://podatki.nijz.si/pxweb/sl/NIJZ%20podatkovni%20portal/NIJZ%20podatkovni%20portal__3%20Zdravstveno%20stanje%20prebivalstva__3a%20Umrli/?rxid=1bcad944-2947-4c49-8ea7-dfb7131f00e9)
* (http://www.stat.si/StatWeb/glavnanavigacija/podatki/prikazistaronovico?IdNovice=4013)


## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Spletni vmesnik

Spletni vmesnik se nahaja v datotekah v mapi `shiny/`. Poženemo ga tako, da v
RStudiu odpremo datoteko `server.R` ali `ui.R` ter kliknemo na gumb *Run App*.
Alternativno ga lahko poženemo tudi tako, da poženemo program `shiny.r`.

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `httr` - za pobiranje spletnih strani
* `XML` - za branje spletnih strani
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
