rm(list=ls())
library(reshape2)
library(dplyr)
library(emmeans)
refpath<-"/home/janeoeaf/documents/barbara/blue/input/"
output_name<-'/home/janeoeaf/documents/barbara/blue/output/blue.csv'

#f0<-'https://www.dropbox.com/s/rh2f3rutf8xtcjr/WiDiv_panel_Years.txt?dl=1'
f1<-'https://www.dropbox.com/s/d6e1d8k9zeczjc4/WiDiv_skNIR1_traits_removed_outliers_year_nursery_info_400samples.txt?dl=1'
f2<-'https://www.dropbox.com/s/wyvjeo6ygssnilk/WiDiv_skNIR2_traits_removed_outliers_year_nursery_info_465samples.txt?dl=1'


#download.file(f0,paste0(refpath,'WiDiv_panel_Years.txt'))
download.file(f1,paste0(refpath,'WiDiv_skNIR1_traits_removed_outliers_year_nursery_info_400samples.txt'))
download.file(f2,paste0(refpath,'WiDiv_skNIR2_traits_removed_outliers_year_nursery_info_465samples.txt'))


#d0<-read.table(paste0(refpath,'WiDiv_panel_Years.txt'),h=T)
d1<-read.table(paste0(refpath,'WiDiv_skNIR1_traits_removed_outliers_year_nursery_info_400samples.txt'),h=T)
d2<-read.table(paste0(refpath,'WiDiv_skNIR2_traits_removed_outliers_year_nursery_info_465samples.txt'),h=T)
d<-d1 %>% bind_rows(d2) %>% mutate(year=substring(Field_ID,5,6),season=substring(Field_ID,3,4))

dl<-melt(data=d,id.vars=c('Geno_ID','Source_ID','Field_ID','year','season','kernel'))
dl2<-dl %>% group_by(Geno_ID,Source_ID,Field_ID,year,season,kernel,variable) %>% summarize(value=mean(value)) %>% ungroup()


blue<-NULL
i<-unique(dl2$variable)[1]
#for(i in unique(dl2$variable)){
    di<-dl2 %>% filter(variable==!!i)
    fit<-lm(value~Field_ID+Geno_ID,data=di)
    blue<-blue %>% bind_rows(as.data.frame(summary(emmeans(fit,~Geno_ID))) %>% mutate(trait=!!i))
#}


