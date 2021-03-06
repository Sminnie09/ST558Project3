library(tidyverse)


#Load all data
loadData <- function(){
  city <- c("Aotizhongxin", "Changping", "Dingling")
  table <- data.frame()
  for(i in 1:length(city)){
    data <- read_csv(paste0("PRSA_Data_", city[i], "_20130301-20170228.csv"))
    table <- rbind(data, table)
  } 
  return(table[c(2:14,17:18)])
}

# pollutant and vars vector
pols <- names(loadData()[5:10])
vars <- names(loadData()[5:14])


#Filter data for station
filterStation <- function(data, city){
    Station <- data %>% filter(station == city)
    return(Station)
}

#Filter data for station and year
filterStationYear <- function(data, city, year_new){
  StationYear <- data %>% filter(station == city) %>% filter(year == year_new)
  return(StationYear)
}


