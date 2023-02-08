
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


####### Towards a typology of intergenerational reallocation patterns: Clustering of countries based on NTA (and NTTA) age profiles
####### Lili Vargha, Tanja Istenic
####### Work in Progress

####### Visualizing Public Transfers in 50 countries
####### Lili Vargha, Bernhard Binder-Hammer, Gretchen Donehower, and Tanja Istenic: Intergenerational transfers around the world: introducing a new visualization tool NTA Working Papers, 2022.

####### Contact: Lili Vargha (lili.vargha@hu-berlin.de or vargha@demografia.hu)


####### Original data source:
####### 1. Global NTA results (Lee and Mason 2011): https://www.ntaccounts.org/web/nta/show/Browse%20database
####### 2. European AGENTA Project (Istenic et al. 2019): http://dataexplorer.wittgensteincentre.org/nta/


####### Data downloaded from the NTA website: July 2020 (There might have been updates, so please check. Updates will be available in the future.)
####### Data downloaded from AGENTA: November 2022

####### Please note, check-ups and normalization of global NTA results were done in Stata.
####### Updates will be done in the future for fully replicable plots using long databases downloaded from the AGENTA and the NTA website.

####### Last update: 8 February 2023

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


setwd ("C:/Users/varghali/seadrive_root/Lili Var/My Libraries/My Library/NTA/2020")

####### Loading packages

library(tidyverse)
library(readxl)
library(ggplot2)
library(plyr)
library(cowplot)
library(data.table)
library(reshape)
library(patchwork)
library(viridisLite)
library(viridis)
library(readstata13)
library(shiny)
library(sf)
library(devtools)
library(qlcMatrix)


##
## NTA DATA downloaded 2020 June 20
##

setwd("C:/Users/varghali/seadrive_root/Lili Var/My Libraries/My Library/NTA/2020")


## max age is different in the different countries, so we use age 85 as a cutting point
## age 85 == mean(age85+) or
## age81-age85 == age80


nta2 <- read.dta13("nta.dta", nonint.factors= TRUE)

####European normalized NTA age profiles

ntadatamatrixeu <- t(as.matrix(read.DIF("nta2010_wide_Norm2.dif", dec = ".", transpose=TRUE, row.names = 1)))
str(ntadatamatrixeu)

mode(ntadatamatrixeu) <- 'numeric' 
ntaeu <- ntadatamatrixeu [1:86,]
mode(ntaeu) <- 'numeric'
dimnames(ntaeu)[[1]] <- character(0)
ntaeu <- as.data.frame(ntaeu)

###Linking together normalized non-EU countries (nta2) and normalized EU countries (ntaeu)

NTA <- cbind (nta2, ntaeu)
class(NTA)


### selecting only TG variables, 51 countries

TGvar <- c( "TG_AT", "TG_BE", "TG_BG", "TG_CY", "TG_CZ", "TG_DK", "TG_EE", "TG_FI", "TG_FR",
            "TG_DE", "TG_GR", "TG_HU", "TG_IE", "TG_IT", "TG_LV", "TG_LT", "TG_LU", "TG_PL",
            "TG_PT", "TG_RO", "TG_SK", "TG_SI", "TG_ES", "TG_SE", "TG_UK", "TG_AR", "TG_AU",
            "TG_BR", "TG_CN", "TG_CO", "TG_CR", "TG_SV", "TG_IN", "TG_ID", "TG_JM", "TG_JP",
            "TG_MX", "TG_MD", "TG_MZ", "TG_NG", "TG_PE", "TG_SN", "TG_SG", "TG_ZA",
            "TG_KR", "TG_TW", "TG_TH", "TG_TR", "TG_UY", "TG_US", "age")

NTATG <- NTA[TGvar]
NTATG


colnames(NTATG)

countries <- c("Austria", "Belgium", "Bulgaria", "Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland",
               "France", "Germany", "Greece", "Hungary", "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg",
               "Poland", "Portugalia", "Romania", "Slovakia", "Slovenia", "Spain", "Sweden", "United Kingdom", "Argentina",
               "Australia", "Brazil", "China", "Colombia", "Costa Rica", "El Salvador", "India", "Indonesia", "Jamaica",
               "Japan", "Mexico", "Moldova", "Mozambique", "Nigeria", "Peru",
               "Senegal", "Singapore", "South Africa", "South Korea", "Taiwan", "Thailand", "Turkey", "Uruguay", "United States")

names(NTATG)

NTATGc <- rename(NTATG, c("TG_AT"="Austria 2010", "TG_BE"="Belgium 2010","TG_BG"="Bulgaria 2010", "TG_CY"="Cyprus 2010", "TG_CZ"="Czech Republic 2010",
                            "TG_DK"="Denmark 2010", "TG_EE"="Estonia 2010", "TG_FI"="Finland 2010", "TG_FR"="France 2010", "TG_DE"="Germany 2010", "TG_GR"="Greece 2010",
                            "TG_HU"="Hungary 2010","TG_IE"= "Ireland 2010", "TG_IT"="Italy 2010", "TG_LV"="Latvia 2010", "TG_LT"="Lithuania 2010", "TG_LU"="Luxembourg 2010",
                            "TG_PL"="Poland 2010","TG_PT"="Portugalia 2010", "TG_RO"="Romania 2010", "TG_SK"="Slovakia 2010", "TG_SI"="Slovenia 2010", "TG_ES"="Spain 2010",
                            "TG_SE"="Sweden 2010", "TG_UK"="United Kingdom 2010", "TG_AR"= "Argentina 2016","TG_AU"="Australia 2010",
                            "TG_BR"="Brazil 2002", 
                            "TG_CN"="China 2002", "TG_CO"="Colombia 2014", "TG_CR"="Costa Rica 2013", "TG_SV"="El Salvador 2010", 
                            "TG_IN"="India 2004", "TG_ID"="Indonesia 2005",
                            "TG_JM"="Jamaica 2002", "TG_JP"="Japan 2004", "TG_MX"="Mexico 2004",
                            "TG_MD"="Moldova 2014", "TG_MZ"="Mozambique 2008", "TG_NG"="Nigeria 2004",
                            "TG_PE"="Peru 2014","TG_SN"="Senegal 2005",
                            "TG_SG"="Singapore 2013", "TG_ZA"="South Africa 2005", "TG_KR"="South Korea 2012", "TG_TW"="Taiwan 2015", "TG_TH"="Thailand 2011",
                            "TG_TR"="Turkey 2006", "TG_UY"="Uruguay 2013", "TG_US"="United States 2011"))

rownames(NTATGc)
rownames(NTATGc) <- NTATGc$age

NTATGh <- t(as.matrix(NTATGc))

colnames(NTATGh)

TGheatmap <- heatmap(NTATGh, Rowv=NA, Colv=NA)

#deleting row age 
NTATGh <- NTATGh[-c(51),]

##maximum and minimum values in the matrix
maxTG <- max(NTATGh)
minTG <- min(NTATGh)

maxTG
minTG

####Sorting: three different versions

#1. Sort the data by the maximum place
#max <- as.numeric(max.col(NTATGh))
#NTATGhs <- cbind(NTATGh, max)
#NTATGhso <- NTATGhs[order(-NTATGhs[,87]),]


#2. sort the data according to when values turn negative
neg <- as.numeric(max.col(NTATGh < 0,ties.method = "first"))
neg

#3. sort the data according to how many ages have negative values
#neg <- as.numeric(rowMeans(NTATGh < 0))
#neg

NTATGhs <- cbind(NTATGh, neg)

NTATGhso <- NTATGhs[order(-NTATGhs[,87]),]

#making a list of countries in order

NTATGhsor <- as.data.frame(NTATGhso)
Tborder <- setDT(NTATGhsor, keep.rownames = TRUE)[]
names(Tborder)[1] <- "country"

corder <- c(Tborder$country)
corder

#deleting the sorting coloumn
NTATGhso <- NTATGhso[,-c(87)]

TGheatmap <- heatmap(NTATGhso, Rowv=NA, Colv=NA)

####GGPLOT

#restructuring the data
TGdf <- as.data.frame(NTATGhso)

#install.packages("data.table")
#library(data.table)
TGd <- setDT(TGdf, keep.rownames = TRUE)[]
names(TGd)[1] <- "country"

#Reorder Data for ggplot2 plot
TGmelt <- melt(TGd)

TGmelt
str(TGmelt)

#reorder the country names 

TGmelt$country <- factor(x = TGmelt$country,
                          levels = corder,
                          ordered = TRUE)

TGtiles <- ggplot(TGmelt, aes(x=as.numeric(variable), y=country))+
  geom_tile(aes(fill=value), colour="White")+
  theme_classic()+
  scale_fill_distiller(palette="Spectral")+
  scale_y_discrete(name="", expand=c(0,0))+
  scale_x_discrete(name="Age", expand=c(0,0))+
  labs(title="Public transfers by age",
       caption="Data from Lee and Mason 2011, Istenic et al. 2019. For replication files and details see: https://github.com/LiliVargha/Public-Transfers-TG-")+
  theme(axis.line.y=element_blank(), plot.subtitle=element_text(size=rel(0.78)), plot.title.position="plot",
        axis.text.y=element_text(colour="Black"))                                                          
TGtiles


age<- c("0", "10", "20","30", "40", "50", "60", "70", "80")

TGtiles <- ggplot(TGmelt, aes(x=as.numeric(variable), y=country))+
  geom_tile(aes(fill=value), colour="White")+
  theme_classic()+
  scale_fill_distiller(palette="Spectral")+
  scale_y_discrete(name="", expand=c(0,0))+
  scale_x_continuous(name="Age", expand=c(0,0), breaks=seq(1, 85, by=10), labels=(age))+
  theme(axis.text.y = element_text(size = 5)) +
  labs(title="",
       caption="")+
  labs(title="Public transfers by age",
       caption="Data from Lee and Mason 2011, Istenic et al. 2019. Replication files & details see: https://github.com/LiliVargha/Public-Transfers_TG")+
  theme(axis.line.y=element_blank(), plot.subtitle=element_text(size=rel(0.78)), plot.title.position="plot",
        axis.text.y=element_text(colour="Black"))   
                                                          
TGtiles


bl <- colorRampPalette(c("navy","royalblue","lightskyblue"))(200)                      
re <- colorRampPalette(c("mistyrose", "red2", "darkred"))(200)
age<- c("0", "10", "20","30", "40", "50", "60", "70", "80")

maxTG
minTG


#Final figure with captions


TGtiles <- ggplot(TGmelt, aes(x=as.numeric(variable), y=country))+
  geom_tile(aes(fill=value), colour="White")+
  theme_classic()+
  scale_fill_gradientn(colours=c(bl, re), na.value = "grey98",
                       limits = c(-1, 1)) +
  scale_y_discrete(name="", expand=c(0,0))+
  scale_x_continuous(name="Age", expand=c(0,0), breaks=seq(1, 85, by=10), labels=(age))+
  labs(title="Net public transfers by age in 50 countries (2002-2016)",
       subtitle=paste0("Net public transfers are the age specific differences between public transfer inflows (benefits) and outflows (contributions) that are mediated by the public sector. The most important public
transfer inflows are pensions, education, health services and general public services. The outflows consist mainly of taxes and social contributions registered in National Accounts. The
figure shows which generations are net beneficiaries of public transfers (shown in red colours) and net givers (shwon in blue colours). The values at each age are normalised using the
average labour income of age 30-49.
                      "),
       caption="Data from Lee and Mason 2011, Istenic et al. 2019. Replication files & details: https://github.com/LiliVargha/Public-Transfers_TG")+
  theme(axis.line.y=element_blank(), plot.subtitle=element_text(size=rel(0.78)), plot.title.position="plot",
        axis.text.y=element_text(colour="Black"),
        axis.text.x=element_text(size=12)) +
  labs(fill = "TG") +
  theme(axis.text.y = element_text(size = 10)) +
  theme(plot.subtitle = element_text(size=12)) +
  theme(plot.title = element_text(size=20)) +
  theme(axis.title.x = element_text(size=14)) +
  theme(plot.caption = element_text(size=12)) +
  theme(legend.title = element_text(size = 12),
        legend.text = element_text(size = 12))

TGtiles 

tiff("Outputs/GitHub/VizTG.tiff", units="in", width=14, height=16, res=500)
plot_grid(TGtiles, align="h", rel_widths=c(1,0.2))
dev.off()

png("Outputs/GitHub/VizTG.png", units="in", width=14, height=16, res=500)
plot_grid(TGtiles, align="h", rel_widths=c(1,0.2))
dev.off()

jpeg("Outputs/GitHub/VizTG.jpg", units="in", width=14, height=16, res=500)
plot_grid(TGtiles, align="h", rel_widths=c(1,0.2))
dev.off()


#Final figure without captions


TGtiles <- ggplot(TGmelt, aes(x=as.numeric(variable), y=country))+
  geom_tile(aes(fill=value), colour="White", linewidth=0.45)+
  theme_classic()+
  scale_fill_gradientn(colours=c(bl, re), na.value = "grey98",
                       limits = c(-1, 1)) +
  scale_y_discrete(name="", expand=c(0,0))+
  scale_x_continuous(name="Age", expand=c(0,0), breaks=seq(1, 85, by=10), labels=(age))+
  labs(title="Public transfers in 50 countries",
       subtitle=paste0(""),
       caption="Data from Lee and Mason 2011, Istenic et al. 2019
       Replication files & details: https://github.com/LiliVargha/Public-Transfers_TG")+
   theme(axis.line.y=element_blank(), plot.subtitle=element_text(size=rel(0.78)), plot.title.position="plot",
        axis.text.y=element_text(colour="Black"),
        axis.text.x=element_text(size=12)) +
  theme(plot.caption.position = "plot",
        plot.caption = element_text(hjust = 1))  +
  theme(axis.text.y = element_text(size = 14)) +
  theme(plot.subtitle = element_text(size=12)) +
  theme(plot.title = element_text(size=20)) +
  theme(axis.title.x = element_text(size=16)) +
  theme(plot.caption = element_text(size=14)) +
  theme(legend.title = element_text(size = 14),
        legend.text = element_text(size = 14))

TGtiles 

jpeg("Outputs/GitHub/VizTG.jpg", units="in", width=18, height=14, res=500)
plot_grid(TGtiles, align="h", rel_widths=c(1,0.2))
dev.off()


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#######
####### Looking for clusters of countries
#######


####### First calculating dissimilarity matrix

####### Using different cluster methods


library(cluster)
library(WeightedCluster)
library(TraMineR)

library(factoextra)
library(ggplot2)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

####### Dissmilarity/distance matrix, NTATGhso

ntamatrix <- as.matrix(NTATGhso)

ntamatrix
str(ntamatrix)


####### Standardise the age specific variables

ntamatrix <- scale(ntamatrix)

TGdismatrix <- as.matrix(daisy(ntamatrix))

str(TGdismatrix)

TGdismatrix[1:5,1:5]

####### Hierarchical clustering 

cluster1 <- hclust(as.dist(TGdismatrix), 
                   method = "ward.D")

#plot the dendrogram

plot(cluster1, 
     labels = FALSE, 
     ylab="Dissimilarity threshold")


wardtest <- as.clustrange(cluster1,
                          diss=TGdismatrix,
                          ncluster=9)
wardtest


#choosing 2 clusters

cluster1.2 <- cutree(cluster1, 
                     k = 2)

cluster1.2

summary(silh.ward <- silhouette(cluster1.2, dmatrix = TGdismatrix))

plot(silh.ward, 
     main = "Silhouette WARD solution", 
     col = "blue",
     border = NA)

#choosing 4 clusters

cluster1.4 <- cutree(cluster1, 
                     k = 4)

cluster1.4

summary(silh.ward <- silhouette(cluster1.4, dmatrix = TGdismatrix))

plot(silh.ward, 
     main = "Silhouette WARD solution", 
     col = "blue",
     border = NA)

#choosing 3 clusters

cluster1.3 <- cutree(cluster1, 
                     k = 3)

cluster1.3

summary(silh.ward <- silhouette(cluster1.3, dmatrix = TGdismatrix))

plot(silh.ward, 
     main = "Silhouette WARD solution", 
     col = "blue",
     border = NA)

#3 clusters seem the best solution



#test different cluster solutions

pam <- wcKMedRange(TGdismatrix, 
                   kvals = 2:15)

#print the quality test for different cluster solutions

pam 

#apply the PAM-clustering algorithm

pam2 <- wcKMedoids(TGdismatrix, 
                   k = 2)

pam2 <- pam2$clustering 

table(pam2)

#2 cluster solution seems to be the best

# checking different clustering techniques: ward method seems the best
proxmat <- dist(TGdismatrix, method = 'euclidean')

m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

ac <- function(x) {
  agnes(TGdismatrix, method = x)$ac
}

map_dbl(m, ac)

#PLOT different solutions


#TGd$cluster4 <-  as.factor(cluster1.4)
#TGd$cluster2 <-  as.factor(cluster1.2)
TGd$cluster3 <-  as.factor(cluster1.3)



str(TGd)


TGmelt <- melt(TGd)
TGmelt

ggplot(data=TGmelt, aes(x=variable, y=value, group=country))+
  geom_line()

TGmelt$variable <- as.numeric(TGmelt$variable)

age<- as.numeric(c("0", "10", "20","30", "40", "50", "60", "70", "80"))           

fig1 <- ggplot(data=TGmelt, aes(x=variable, y=value, group=country, color=cluster4)) +
  geom_line() +
  theme_minimal() +
  scale_color_manual(values = c("black", "red", "#00AFBB", "blue"), name ="4 Clusters",
                     breaks=c("1", "2", "3", "4"),
                     labels=c("Cluster 1", "Cluster 2", "Cluster 3", "Cluster 4")) +
  scale_x_continuous(name="Age", expand=c(0,0), breaks=seq(1, 85, by=10), labels=(age)) +
  
  labs(title="Public Transfer Age Profile Clusters (N=50)",
       caption="Data from Lee and Mason 2011, Istenic et al. 2019
       Replication files & details: https://github.com/LiliVargha/Public-Transfers_TG") +
  theme(axis.line.y=element_blank(), plot.subtitle=element_text(size=rel(0.78)), plot.title.position="plot",
        axis.text.y=element_text(colour="Black"),
        axis.text.x=element_text(size=12)) +
  theme(axis.text.y = element_text(size = 12)) +
  theme(plot.subtitle = element_text(size=12)) +
  theme(plot.title = element_text(size=16)) +
  theme(axis.title.x = element_text(size=14)) +
  theme(axis.title.y = element_text(size=14)) +
  theme(plot.caption = element_text(size=12)) +
  theme(legend.title = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  scale_y_continuous(name="Normalized Value")
#geom_hline(yintercept=0, colour="black")

fig1 

fig2 <- ggplot(data=TGmelt, aes(x=variable, y=value, group=country, color=cluster2)) +
  geom_line() +
  theme_minimal() +
  scale_color_manual(values = c( "#00AFBB", "red"), name  ="2 Clusters",
                     breaks=c("1", "2"),
                     labels=c("Cluster 1", "Cluster 2")) +
  scale_x_continuous(name="Age", expand=c(0,0), breaks=seq(1, 85, by=10), labels=(age)) +
  labs(title="Public Transfer Age Profile Clusters (N=50)") +
  theme(axis.line.y=element_blank(), plot.subtitle=element_text(size=rel(0.78)), plot.title.position="plot",
        axis.text.y=element_text(colour="Black"),
        axis.text.x=element_text(size=12)) +
  theme(axis.text.y = element_text(size = 12)) +
  theme(plot.subtitle = element_text(size=12)) +
  theme(plot.title = element_text(size=16)) +
  theme(axis.title.x = element_text(size=14)) +
  theme(axis.title.y = element_text(size=14)) +
  theme(plot.caption = element_text(size=12)) +
  theme(legend.title = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  scale_y_continuous(name="Normalized Value")

fig2 




fig3 <- ggplot(data=TGmelt, aes(x=variable, y=value, group=country, color=cluster3)) +
  geom_line() +
  theme_minimal() +
  scale_color_manual(values = c( "navy", "red", "#00AFBB"), name  ="3 Clusters",
                     breaks=c("1", "2", "3"),
                     labels=c("Higher TG ch, slower decrease for working ages, steeper increase for old age (N=14)", "Lower level TG at all ages (N=9)", "Higher TG ch, earlier decrease for working age & increase for elderly (N=27)")) +
  scale_x_continuous(name="Age", expand=c(0,0), breaks=seq(1, 85, by=10), labels=(age)) +
  labs(title="Public Transfer Age Profile Clusters (N=50)",
       caption="Data from Lee and Mason 2011, Istenic et al. 2019
       Replication files & details: https://github.com/LiliVargha/Public-Transfers_TG") +
  theme(axis.line.y=element_blank(), plot.subtitle=element_text(size=rel(0.78)), plot.title.position="plot",
        axis.text.y=element_text(colour="Black"),
        axis.text.x=element_text(size=12)) +
  theme(legend.position="bottom") +
  guides(color = guide_legend(nrow = 3)) +
  theme(axis.text.y = element_text(size = 12)) +
  theme(plot.subtitle = element_text(size=12)) +
  theme(plot.title = element_text(size=16)) +
  theme(axis.title.x = element_text(size=14)) +
  theme(axis.title.y = element_text(size=14)) +
  theme(plot.caption = element_text(size=12)) +
  theme(legend.title = element_text(size = 14),
        legend.text = element_text(size = 14)) +
  scale_y_continuous(name="Normalized Value", limits=c(-0.5,0.9), breaks=c(-0.5,0,0.5,1))

fig3

jpeg("Outputs/GitHub/ClusterTG.jpg", units="in", width=10, height=8, res=500)
plot(fig3, align="h", rel_widths=c(1,0.2))
dev.off()

str(TGd)
cluster1.3

ord <- cbind(corder,cluster1.3)
ord
str(ord)
?order
ord <-ord[order(ord[,2], decreasing = FALSE),]

corder2<-ord[,1]


TGmelt$country <- factor(x = TGmelt$country,
                         levels = corder2,
                         ordered = TRUE)


TGtiles <- ggplot(TGmelt, aes(x=as.numeric(variable), y=country))+
  geom_tile(aes(fill=value), colour="White", linewidth=0.35)+
  theme_classic()+
  scale_fill_distiller(palette="Spectral")+
    labs(title="Public transfers in 50 countries ordered by 3 clusters",
         caption="Data from Lee and Mason 2011, Istenic et al. 2019
       Replication files & details: https://github.com/LiliVargha/Public-Transfers_TG")+
  theme(axis.line.y=element_blank(), plot.subtitle=element_text(size=rel(0.78)), plot.title.position="plot",
        axis.text.y=element_text(colour="Black")) +
  scale_y_discrete(name="", expand=c(0,0))+
  scale_x_continuous(name="Age", expand=c(0,0), breaks=seq(1, 85, by=10), labels=(age))+
  theme(axis.line.y=element_blank(), plot.subtitle=element_text(size=rel(0.78)), plot.title.position="plot",
        axis.text.y=element_text(colour="Black"),
        axis.text.x=element_text(size=12)) +
  labs(fill = "Normalized value") +
  theme(axis.text.y = element_text(size = 10)) +
  theme(plot.subtitle = element_text(size=12)) +
  theme(plot.title = element_text(size=20)) +
  theme(axis.title.x = element_text(size=14)) +
  theme(plot.caption = element_text(size=12)) +
  theme(legend.title = element_text(size = 12),
        legend.text = element_text(size = 12))
TGtiles


jpeg("Outputs/GitHub/ClusterTGtiles.jpg", units="in", width=12, height=8, res=500)
plot(TGtiles, align="h", rel_widths=c(1,0.2))
dev.off()

TGtiles <- ggplot(TGmelt, aes(x=as.numeric(variable), y=country))+
  geom_tile(aes(fill=value), colour="White")+
  theme_classic()+
  scale_fill_gradientn(colours=c(bl, re), na.value = "grey98",
                       limits = c(-1, 1)) +
  scale_y_discrete(name="", expand=c(0,0))+
  scale_x_continuous(name="Age", expand=c(0,0), breaks=seq(1, 85, by=10), labels=(age))+
  theme(axis.line.y=element_blank(), plot.subtitle=element_text(size=rel(0.78)), plot.title.position="plot",
        axis.text.y=element_text(colour="Black"),
        axis.text.x=element_text(size=12)) +
  labs(fill = "Normalised value") +
  theme(axis.text.y = element_text(size = 10)) +
  theme(plot.subtitle = element_text(size=12)) +
  theme(plot.title = element_text(size=20)) +
  theme(axis.title.x = element_text(size=14)) +
  theme(plot.caption = element_text(size=12)) +
  theme(legend.title = element_text(size = 12),
        legend.text = element_text(size = 12))

TGtiles 








