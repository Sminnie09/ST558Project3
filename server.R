library(shiny)
library(tidyverse)

setwd("S:/ST558/Homeworks/Project 3/ST558Project3")

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
city <- c("Aotizhongxin", "Changping", "Dingling")

#Server function
shinyServer(function(input, output) {
  
  #Filtered data for Data Tab
  filterData <- reactive({
      if(input$station != "Select a City"){
        newData <- loadData() %>% filter(station == input$station) 
      }
      else if(input$station != "Select a City" & input$year != "Select a Year"){
        newData <- loadData() %>% filter(station == input$station) %>% filter(year == input$year)
      }
            
    
      #%>% filter(year == input$year) %>% filter(month == input$month)
  })
  
  #filterData <- observe({
   #   if(input$station != "Select a City" & input$year != "Select a Year"){
    #    newData <- loadData() %>% filter(station == input$station) %>% filter(year == input$year)
    #}
    
    
    #%>% filter(year == input$year) %>% filter(month == input$month)
  #})
  
  
  
  #filterDataYear <- reactive({
   # newData <- loadData() %>% filter(station == input$station) %>% filter(year == input$year)
  #})

  #Data Tab
  output$table <- DT::renderDataTable(filterData(), extensions = 'Buttons',
                  options = list(dom = 'Bfrtip',
                  buttons = c('csv', 'excel'))
  
  )
  
  

  
  #Data Exploration
 # output$Plot <- renderPlot({
  #  df <- filterData()
    
    
    
  #})
    


})
