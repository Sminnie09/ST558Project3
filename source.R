library(tidyverse)
library(here)

#setwd("S:/ST558/Homeworks/Project 3/ST558Project3")

#Load all data
loadData <- function(){
  city <- c("Aotizhongxin", "Changping", "Dingling")
  table <- data.frame()
  for(i in 1:length(city)){
    data <- read_csv(paste0("S:/ST558/Homeworks/Project 3/ST558Project3/PRSA_Data_", city[i], "_20130301-20170228.csv"))
    table <- rbind(data, table)
  } 
  return(table[-1])
}


#Load one file for modeling

Dingling_reg <- function(){
  data <- read_csv("S:/ST558/Homeworks/Project 3/ST558Project3/PRSA_Data_Dingling_20130301-20170228.csv")
  data <- data %>% filter(year == "2016")
  return(data[-1])
}


