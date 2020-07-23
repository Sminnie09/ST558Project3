library(tidyverse)
library(here)

setwd("S:/ST558/Homeworks/Project 3/ST558Project3")

loadData <- function(){
  city <- c("Aotizhongxin", "Changping", "Dingling")
  table <- data.frame()
  for(i in 1:length(city)){
    data <- read_csv(paste0("PRSA_Data_", city[i], "_20130301-20170228.csv"))
    table <- rbind(data, table)
  } 
  return(table[-1])
}

#data <- loadData()
#city <- c("Aotizhongxin", "Changping", "Dingling")


