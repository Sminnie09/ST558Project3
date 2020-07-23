library(shiny)
library(tidyverse)


source("S:/ST558/Homeworks/Project 3/ST558Project3/source.R")

#Server function
shinyServer(function(input, output) {
  
  #Filtered data for Data Tab
  filterData <- reactive({
    if(input$station == 'Select a city'){
      filterData <- loadData()
    }
    else if(input$station != 'Select a city' & input$year == 'Select a year'){
      filterData <- loadData() %>% filter(station == input$station)
    }
    else if(input$year != 'Select a year' & input$year != 'Select a year'){
      filterData <- loadData() %>% filter(station == input$station) %>% filter(year == input$year)
    }
  })

  #Save data in data table
  output$table <- DT::renderDataTable(filterData())

  output$download1 <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(filterData(), file)
    }
  )
  

  
  #Data Exploration
 # output$Plot <- renderPlot({
  #  df <- filterData()
    
    
    
  #})
    


})
