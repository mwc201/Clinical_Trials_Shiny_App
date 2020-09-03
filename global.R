library(shinydashboard)
library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)
library(leaflet)
library(DT)
library(lubridate)
library(googleVis)
library(stringr)
library(plotly)

trials <- read.csv('Cardio_studies.csv',
                   header = TRUE,
                   stringsAsFactors = FALSE)

location <- read.csv("final.csv",
                     header = TRUE,)

#DF for table output
df_duration = df %>% 
  filter(., !is.na(Duration)) %>%
  group_by(., Sponsor.Type) %>% 
  summarise(., 
            Avg.Duration = round(mean(Duration), 1), 
            Min.Duration = round(min(Duration), 1), 
            Max.Duration = round(max(Duration), 1)) 

enrollment_df <- df %>% group_by(., Sponsor.Type) %>% 
  filter(., !is.na(Enrollment)) %>% 
  summarise(., 
               #Total.Studies =  ??
               Total_Enrollment = sum(Enrollment),
               Avg.Enrollment = round(mean(Enrollment), 0),   
               Min.Enrollment = min(Enrollment),
               Max.Enrollment = max(Enrollment))


tot_studies <- df %>% 
  group_by(., Sponsor.Type) %>% 
  summarise(., Total_Studies = n()) 


df_1 = inner_join(tot_studies, enrollment_df, by = "Sponsor.Type")
df_2 = inner_join(df_1, df_duration, by = "Sponsor.Type")


