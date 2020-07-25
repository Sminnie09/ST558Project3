library(shiny)
library(tidyverse)
library(plotly)


source("global.R")

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
      filterData <- loadData() %>% filterStationYear(input$station, input$year)
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

      df <- filterDataExplore() %>% filterStationYear(input$stationPlot, input$yearPlot)
 
    if(input$plot == "Histogram"){
      #ggplot(df, mapping = aes(x=input$pollutant)) + geom_histogram()
      #print(input$pollutant)
      dfPol <- as.numeric(unlist(df[input$pollutant]))
      hist(dfPol, breaks = input$bins, xlab = input$pollutant, main = paste("Histogram of", input$stationPlot, input$pollutant, "Concentrations in", input$yearPlot))
    }
    
    if(input$plot == "Boxplot"){
      df <- df[5:10]
      #print(df)
      par(cex.lab=1.25) # is for y-axis
      par(cex.axis=1)
      par(mgp=c(2,1,0)) 
      boxplot(df, xlab("Pollutants"), ylab = expression(paste("Concentration (ug ", m^-3,")")), main = paste("Boxplot of", input$stationPlot, "Pollutant Concentrations in", input$yearPlot))
      par(mgp = c(4,1,0))
  
      
    }
  })
  
  #Data Exploration - Numerical
  output$numSummary <- renderPrint({
      data <- filterDataExplore() %>% filterStationYear(input$stationSum, input$yearSum)
      summary(data[c(5:14, 17)])
  })
  
  #Data Exploration - Change number of obs shown
  observe({updateNumericInput(session, "obs", value = input$obs)})
  
  #Data exploration table of obs
  output$view <- renderTable({
    dataTable <- filterDataExplore() %>% filterStationYear(input$stationSum, input$yearSum)
    head(dataTable, n = input$obs)
  })
  
  #output$text <- renderText({
   # paste0("You are currently viewing", input$obs, "of",nrow(dataTable), "records")
  #})

  #Save histogram
  output$downloadHist <- downloadHandler(

        file = paste("Histogram", '.png', sep=''),
        content = function(file) {
        png(file)
        df <- filterDataExplore() %>% filterStationYear(input$stationPlot, input$yearPlot)
        hist(as.numeric(unlist(df[input$pollutant])), breaks = input$bins, xlab = input$pollutant, main = paste("Histogram of", input$stationPlot, input$pollutant, "Concentrations in", input$yearPlot))
        dev.off()
      }
    )
  
  #Save boxplot
 # output$downloadBox <- downloadHandler(
    
  #    file = paste("Boxplot", '.png', sep=''),
   #   content = function(file) {
    #    df <- filterDataExplore() %>% filterStationYear(input$stationPlot, input$yearPlot)
     #   png(file)
      #par(cex.lab=1.25) # is for y-axis
      #par(cex.axis=1)
      #par(mgp=c(2,1,0)) 
      #boxplot(df, xlab("Pollutants"), ylab = expression(paste("Concentration (ug ", m^-3,")")), 
       #       main = paste("Boxplot of", input$stationPlot, "Pollutant Concentrations in", input$yearPlot))
      #par(mgp = c(4,1,0))
      #dev.off()
    #}
  #)
  
  
  
  #x variable for regression
  x <- reactive({
    #df <- Dingling_reg() %>% filter(month == input$month)
    df <- filterDataExplore() %>% filterStationYear(input$stationReg, input$yearReg) %>% filter(month == input$month)
    df <- as.numeric(unlist(df[input$xcol]))
    
  })
  
  #y variable for regression
  y <- reactive({
    df <- filterDataExplore() %>% filterStationYear(input$stationReg, input$yearReg) %>% filter(month == input$month)
    df <- as.numeric(unlist(df[input$ycol]))
  })
  
  #Change month in slider
  observe({updateSliderInput(session, "month", value = input$month)})
  
#Regression Plot
  output$regression <- renderPlotly(
    if(input$regEqu == TRUE){
      fit <- lm(y() ~ x())
      predict <- predict(fit, newdata = data.frame(x()))
      x <- list(
        title = paste(input$xcol, "Concentration ug/m^3")
      )
      y <- list(
        title = paste(input$ycol, "Concentration ug/m^3")
      )
      plot_ly(x = x(), y = y(), type = 'scatter', mode = 'markers', name = "Concentration") %>% add_lines(x = x(), y = predict, name = "Regression Line") %>% layout(xaxis = x, yaxis = y, 
                                                                                                                                                                     title = paste("Simple Linear Regression:", 
                                                                                                                                                                                   "X =", input$xcol,
                                                                                                                                                                                   " , Y = ", input$ycol))
    }
    else{
      x <- list(
        title = paste(input$xcol, "Concentration ug/m^3")
      )
      y <- list(
        title = paste(input$ycol, "Concentration ug/m^3")
      )
      plot<-plot_ly(x = x(), y = y(), type = 'scatter', mode = 'markers') %>% layout(xaxis = x, yaxis = y, title = paste("Pollutant Concentrations in", input$stationReg, "in", input$yearReg))
    }
      
  )
  

  #Observe checkbox for regression equation
  observeEvent(input$regEqu,{
  })
  
  #Regression equation
  output$regressionEqu <- renderPrint({
    
    if(input$regEqu == TRUE){
    fit <- lm(y() ~ x())
    fit
    }
  })
  
  output$regTable <- renderTable({
    
    if(input$regEqu == TRUE){
      data <- data.frame(x = x(), yPredict = predict(lm(y() ~ x()), newdata = data.frame(x())))
      head(data, n = 20)
    }
      
  })
  
  
  #### Random Forest Model
  #varsRF <- renderUI({
   # if(input$stationRF != 'Select a city' & input$yearRF != 'Select a year'){
      
    #}
  #})
  
})
