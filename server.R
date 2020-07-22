library(shiny)
library(tidyverse)

loadData <- function(){
  city <- c("Aotizhongxin", "Changping", "Dingling")
  table <- data.frame()
  for(i in 1:length(city)){
    data <- read_csv(paste0("PRSA_Data_", city[i], "_20130301-20170228.csv"))
    table <- rbind(data, table)
  } 
  return(table)
}

data <- loadData()

#Server function
shinyServer(function(input, output) {

  filterData <- reactive({
    newData <- loadData() %>% filter(station == input$station)
  })  
  
  

  output$table <- renderTable(filterData())


})
