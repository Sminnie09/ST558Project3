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
    else if(input$station != 'Select a city' & input$year != 'Select a year'){
      filterData <- loadData() %>% filter(station == input$station) %>% filter(year == input$year)
    }
  })
  
  #Data for data exploration graphs
  filterDataExplore <- reactive({
      filterDataExplore <- loadData()
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
  

  #Data Exploration - Graphical
  output$plot <- renderPlot({
    df <- filterDataExplore()
    #pol <- as.name(input$pollutant)
    if(input$plot == "Histogram"){
      #ggplot(df, mapping = aes(x=input$pollutant)) + geom_histogram()
      #print(input$pollutant)
      df <- as.numeric(unlist(df[input$pollutant]))
      hist(df, breaks = input$bins, xlab = input$pollutant, main = paste("Histogram of", input$pollutant))
    }
    if(input$plot == "Boxplot"){
      df <- filterDataExplore()[5:10]
      boxplot(df)
      
    }
  })
  
  #Data Exploration - Numerical
  output$numSummary <- renderPrint({
      data <- filterDataExplore()
      summary(data[c(5:14, 16)])
  })
  
  observe({updateNumericInput(session, "obs", value = input$obs)})
  
  output$view <- renderTable({
    head(filterDataExplore(), n = input$obs)
  })

  #Save histogram
  output$downloadHist <- downloadHandler(

        file = paste("Histogram", '.png', sep=''),
      content = function(file) {
        png(file)
        #hist(iris$Sepal.Length)
        #ggsave(file, plot = plot(), device = "png")
        hist(as.numeric(unlist(filterDataExplore()[input$pollutant])), breaks = input$bins, xlab = input$pollutant, main = paste("Histogram of", input$pollutant))
        dev.off()
      }
    )
  
  #Save boxplot
  output$downloadBox <- downloadHandler(
    
    file = paste("Boxplot", '.png', sep=''),
    content = function(file) {
      png(file)
      #hist(iris$Sepal.Length)
      #ggsave(file, plot = plot(), device = "png")
      boxplot(filterDataExplore()[5:10])
      dev.off()
    }
  )
  

})
