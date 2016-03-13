# 4. faza: Analiza podatkov

#barve <- rainbow(length(levels(obcine[[7]])))
#names(barve) <- levels(obcine[[7]])

a <- inner_join(Prebivalci_regije, Umrli_regije)
a <- data.frame(a %>% group_by(Regija) %>% summarise(St.Prebivalcev=sum(St.Prebivalcev), Umrli=sum(Umrli)))
rownames(a) <- a$Regija
a <- a[,-1]


n <- 3

a.norm <- scale(a)
k <- kmeans(a.norm, n, nstart = 1000)
regije <- row.names(a)
m <- match(zemljevid$NAME_1, regije)
zemljevid$skupina <- factor(k$cluster[regije[m]])


ZEM1 <- ggplot() + geom_polygon(data = pretvori.zemljevid(zemljevid), 
                               aes(x=long, y=lat, group=group, fill=skupina),
                               color = "grey")

ZEM1 <- ZEM1 + geom_text(data = SLO %>% group_by(id, NAME_1) %>% summarise(x = mean(long), y = mean(lat)),
                 aes(x = x, y = y, label = NAME_1), size = 2.5)

ZEM1 <- ZEM1 + labs(x="", y="")+
  scale_y_continuous(breaks=NULL)+
  scale_x_continuous(breaks=NULL)+
  theme_minimal()

print(ZEM1)

##CENTROIDI
razdalje <- apply(k$centers, 1, function(y) apply(a.norm, 1, function(x) sum((x-y)^2)))
min.razdalje <- apply(razdalje, 2, min)
manj.razdalje <- apply(razdalje, 1, function(x) x == min.razdalje)
najblizje <- apply(manj.razdalje[,apply(manj.razdalje, 2, any)], 2, which)
REG <- names(najblizje)[order(najblizje)]




#graf: STAROST-ŠT.UMRLIH:


podatki <- umrli.starost %>% group_by(Starost) %>% summarise(Umrli = sum(Umrli))

GRAF1 <- ggplot(podatki, aes(x=Starost, y=Umrli)) + 
  geom_point(stat = "identity") + 
  labs(title ="Št. umrlih, glede na starost")+
  theme_bw()

print(GRAF1)

###
model.loess <- loess(data = podatki, Starost ~ Umrli)
GRAF1 + geom_smooth(method = "loess")
sum(model.loess$residuals^2) # 15665.45
#očitno velika napaka

model <- lm(data = podatki, Umrli ~ Starost)
sum(model$residuals^2) # 60584308
#Še večja napaka


model <- lm(data = podatki, Umrli ~ Starost + I(Starost^2) + I(Starost^3) + I(Starost^4) + I(Starost^5) + I(Starost^6))
sum(model$residuals^2) # 0.01712185

GRAF1 + geom_smooth(method = "lm", formula = y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5)+ I(x^6))


ggplot(podatki, aes(x = Starost, y = Umrli)) + xlim(0, 110) + geom_point() +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5)+ I(x^6)+ I(x^7) + I(x^8), se = FALSE,
              fullrange = TRUE, color = "green")

## št. umrlih narašča s starostjo potem pa pada - najverjetneje zato, ker je manj prebivalcev, starih nad 90let..

## Umrli glede na število prebivalcev oz. procent umrlih po starosti:
## Uvozim novo tabelo v uvoz.r za lažjo analizo in narišem graf, ki prikazuje procent umrlih glede na starost:



mgam <- gam(data = TABELA3, Procent.umrlih ~ s(Starost))
sum(mgam$residuals^2) #29.10676

metoda <- lm(data = TABELA3, Procent.umrlih ~ Starost + I(Starost^2) + I(Starost^3) + I(Starost^4) + I(Starost^5))
sum(metoda$residuals^2) #34.02544

metoda <- lm(data = TABELA3, Procent.umrlih ~ Starost+ I(Starost^(3))+ I(Starost^5)+ I(Starost^7) + I(Starost^(9)+ I(Starost^11)))
sum(metoda$residuals^2)



GRAF2 <- ggplot(TABELA3, aes(x=Starost,y=Procent.umrlih))+
  geom_point(stat = "identity")+
  labs(title ="Procent umrlih glede na starost")+
  theme_bw()
GRAF2 + geom_smooth(method = "gam", formula = y ~ s(x))
print(GRAF2)

ggplot(TABELA3, aes(x = Starost, y = Procent.umrlih)) + geom_point() +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5), se = FALSE,
              fullrange = TRUE, color = "green")
