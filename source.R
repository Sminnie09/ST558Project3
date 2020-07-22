library(tidyverse)

loadData <- function(){
  city <- c("Aotizhongxin", "Changping", "Dingling")
  table <- data.frame()
  for(i in 1:length(city)){
    data <- read_csv(paste0("S:/ST558/Homeworks/Project 3/ST558Project3/FinalProject/","PRSA_Data_", city[i], "_20130301-20170228.csv"))
    table <- rbind(data, table)
  } 
  return(table)
}


