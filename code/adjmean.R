rm(list=ls())
library(reshape2)
library(dplyr)
library(emmeans)
library(lme4)
#if(!require('lmerTest')) install.packages('lmerTest')
#library(lmerTest)
ar<-commandArgs(T)
#ar[1]<-'1'
#ar[2]<-"/orange/rgenomics/gomide/barbara/blue/input/"
#ar[3]<-'/orange/rgenomics/gomide/barbara/blue/output/blue'
print(ar)
i<-as.numeric(ar[1])
refpath<-ar[2]
output_name<-ar[3]

#f0<-'https://www.dropbox.com/s/rh2f3rutf8xtcjr/WiDiv_panel_Years.txt?dl=1'
f1<-'https://www.dropbox.com/s/d6e1d8k9zeczjc4/WiDiv_skNIR1_traits_removed_outliers_year_nursery_info_400samples.txt?dl=1'
f2<-'https://www.dropbox.com/s/wyvjeo6ygssnilk/WiDiv_skNIR2_traits_removed_outliers_year_nursery_info_465samples.txt?dl=1'


#download.file(f0,paste0(refpath,'WiDiv_panel_Years.txt'))
#download.file(f1,paste0(refpath,'WiDiv_skNIR1_traits_removed_outliers_year_nursery_info_400samples.txt'))
#download.file(f2,paste0(refpath,'WiDiv_skNIR2_traits_removed_outliers_year_nursery_info_465samples.txt'))


#d0<-read.table(paste0(refpath,'WiDiv_panel_Years.txt'),h=T)
d1<-read.table(paste0(refpath,'WiDiv_skNIR1_traits_removed_outliers_year_nursery_info_400samples.txt'),h=T)
d2<-read.table(paste0(refpath,'WiDiv_skNIR2_traits_removed_outliers_year_nursery_info_465samples.txt'),h=T)
d<-d1 %>% bind_rows(d2) %>% mutate(year=substring(Field_ID,5,6),season=substring(Field_ID,3,4))

dl<-melt(data=d,id.vars=c('Geno_ID','Source_ID','Field_ID','year','season','kernel'))
dl2<-dl %>% group_by(Geno_ID,Source_ID,Field_ID,year,season,kernel,variable) %>% summarize(value=mean(value)) %>% ungroup()


blue<-NULL
variables<-unique(dl2$variable)
trait<-variables[i]
#emm_options(pbkrtest.limit = 1e6)
di<-dl2 %>% filter(variable==!!trait)
#fit<-lm(value~Field_ID+Geno_ID,data=di)
fit<-lmer(value~(1|Field_ID)+Geno_ID,data=di)
blue<-as.data.frame(summary(emmeans(fit,~Geno_ID))) %>% mutate(trait=!!trait)

readr::write_csv(blue,paste0(output_name,i,'.csv'))
