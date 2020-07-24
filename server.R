library(shiny)
library(tidyverse)
library(ggplot2)


source("S:/ST558/Homeworks/Project 3/ST558Project3/source.R", local = environment())

#Server function
shinyServer(function(input, output, session) {
  #source("S:/ST558/Homeworks/Project 3/ST558Project3/source.R", local = TRUE)
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
  
  
  filterDataExplore <- reactive({
    #source("S:/ST558/Homeworks/Project 3/ST558Project3/source.R", local = TRUE)
    library(tidyverse)
    if(input$summaries == 'Graphical'){
      #source("S:/ST558/Homeworks/Project 3/ST558Project3/source.R", local = TRUE)
      filterDataExplore <- loadData()
      #print(head(filterDataExplore))
      #print(head(filterDataExplore[input$pollutant]))
    }

      #pol <- input$pollutant
      #data <- data[pol]
      #print(pol)
      #print(head(data))
    
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
  output$plot <- renderPlot({
    df <- filterDataExplore()
    #pol <- as.name(input$pollutant)
    if(input$plot == "Histogram"){
      #ggplot(df, mapping = aes(x=input$pollutant)) + geom_histogram()
      #print(input$pollutant)
      df <- as.numeric(unlist(df[input$pollutant]))
      hist(df, breaks = input$bins, xlab = input$pollutant, main = paste("Histogram of", input$pollutant))
    }
  })

    
    
    
  #})
    


})
