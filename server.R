library(shiny)
library(tidyverse)
library(plotly)
library(randomForest)
library(caret)
library(e1071)

#Global source file
source("global.R")

#Server function
shinyServer(function(input, output, session) {

  #Filtered data for Data Tab
  filterData <- reactive({
    if(input$Alldata == TRUE){
      filterData <- loadData()
    }
    
    else{
      filterData <- loadData() %>% filterStationYear(input$station, input$year) %>% filter(month == input$month)
    }
      
  })
  
  #Data for data exploration graphs
  filterDataExplore <- reactive({
      filterDataExplore <- loadData()
  })
  

  #Data table for data tab
  output$table <- DT::renderDataTable(filterData())

  #function to download the data table in the data tab
  output$download1 <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(filterData(), file)
    }
  )
  

  ### Data Exploration tab - Graphical Summaries
  output$plot <- renderPlot({

      df <- filterDataExplore() %>% filterStationYear(input$stationPlot, input$yearPlot) #filter data
    
      #Histogram
    if(input$plot == "Histogram"){
      #ggplot(df, mapping = aes(x=input$pollutant)) + geom_histogram()
      #print(input$pollutant)
      dfPol <- as.numeric(unlist(df[input$pollutant]))
      hist(dfPol, breaks = input$bins, xlab = input$pollutant, main = paste("Histogram of", input$stationPlot, input$pollutant, "Concentrations in", input$yearPlot))
    }
    
      #Boxplot
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
  
  
  ####Data Exploration tab - Numerical Summaries
  output$numSummary <- renderPrint({
      data <- filterDataExplore() %>% filterStationYear(input$stationSum, input$yearSum)
      summary(data[c(5:14)])
  })
  
  
  #Data Exploration tab - Change number of obs shown in data table
  observe({updateNumericInput(session, "obs", value = input$obs)})
  
  #Data exploration -  table of obs
  output$view <- renderTable({
    dataTable <- filterDataExplore() %>% filterStationYear(input$stationSum, input$yearSum)
    head(dataTable, n = input$obs)
  })
  

  #Save histogram as png file
  output$downloadHist <- downloadHandler(

        file = paste("Histogram", '.png', sep=''),
        content = function(file) {
        png(file)
        df <- filterDataExplore() %>% filterStationYear(input$stationPlot, input$yearPlot)
        hist(as.numeric(unlist(df[input$pollutant])), breaks = input$bins, xlab = input$pollutant, main = paste("Histogram of", input$stationPlot, input$pollutant, "Concentrations in", input$yearPlot))
        dev.off()
      }
    )
  
#### Regression Model

  #x variable for regression
  x <- reactive({
    #df <- Dingling_reg() %>% filter(month == input$month)
    df <- filterDataExplore() %>% filterStationYear(input$stationReg, input$yearReg) %>% filter(month == input$monthReg) %>% na.omit()
    df <- as.numeric(unlist(df[input$xcol]))
    
  })
  
  #y variable for regression
  y <- reactive({
    df <- filterDataExplore() %>% filterStationYear(input$stationReg, input$yearReg) %>% filter(month == input$monthReg) %>% na.omit()
    df <- as.numeric(unlist(df[input$ycol]))
  })
  
  #Change month in slider for regression
  observe({updateSliderInput(session, "month", value = input$monthReg)})
  
  
  #Regression Calculation with repeated cross validation
  regression <- reactive({
    
    if(input$regEqu == TRUE){
    set.seed(123)
    df <- data.frame(x(), y())
    colnames(df) <- c(input$xcol, input$ycol)
    #df <- dplyr::select(df, -input$vars1)
    train <- sample(1:nrow(df), size = nrow(df)*0.8)
    test <- dplyr::setdiff(1:nrow(df), train)
    dfTrain <- df[train, ]
    dfTest <- df[test, ]
    
    set.seed(123)
    trCtrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
    #print(trCtrl)
    lmFit <- train(as.formula(paste(input$ycol,"~", input$xcol)), data = dfTrain, method = "lm",
                   trControl = trCtrl)
    
  
    predict <- predict(lmFit, newdata = data.frame(dfTest))
    
    list(lmFit = lmFit, predict = predict, dfTest = dfTest)
    
    }
  })

  
 #Regression Plot - add regression line to scatter plot
  output$regressionPlot <- renderPlotly(
    if(input$regEqu == TRUE){
      

      x <- list(
        title = paste(input$xcol, "Concentration ug/m^3")
      )
      y <- list(
        title = paste(input$ycol, "Concentration ug/m^3")
      )
      
      #Regression plot
      model <-  (coef(regression()$lmFit$finalModel)[2] * x()) + coef(regression()$lmFit$finalModel)[1]
      plot_ly() %>% add_trace(x = x(), y = y(), type = 'scatter', mode = 'markers', name = "Concentration") %>% add_lines(x = x(), y = model, name = "Regression Line") %>% layout(xaxis = x, yaxis = y, 
                                                                                                                                                                     title = paste("Simple Linear Regression:", 
                                                                                                                                                                                "X =", input$xcol,
                                                                                                                                                                              " , Y = ", input$ycol),showlegend = F)
    }
    #Scatter plot
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
  
  #Regression equation using MathJax() on Information page
  output$SLR <- renderUI({
    withMathJax(
      '$$Y_i = \\beta_0 + \\beta_1 x_i$$'
    )
  })
  
  #Observe checkbox for regression equation
  observeEvent(input$regEqu,{
  })
  
  #Regression equation results 
  output$regressionEqu <- renderPrint({
    
    if(input$regEqu == TRUE){
    fit <- summary(regression()$lmFit)
    fit
    }
  })
  
  #regression data table
  output$regTable <- DT::renderDataTable({
    
    if(input$regEqu == TRUE){
      data <- data.frame(regression()$dfTest[input$xcol], regression()$dfTest[input$ycol], ypredict = regression()$predict)
      data
    }
      
  })
  
  
  #### Random Forest Model
  
  #reactive variable for random forest model
  RandForest <- reactive({
    
      set.seed(123)
      df <- filterDataExplore() %>% filterStationYear(input$stationRF, input$yearRF) %>% filter(month == input$monthRF) %>% filter(day == input$dayRF) %>% na.omit()
      #df$class <- ifelse(df[input$vars1] <= 400, "low", "high")
      #df$class <- factor(df$class)
      df <- df[c(5:14)]
      #df <- dplyr::select(df, -input$vars1)
      train <- sample(1:nrow(df), size = nrow(df)*0.8)
      test <- dplyr::setdiff(1:nrow(df), train)
      dfTrain <- df[train, ]
      dfTest <- df[test, ]
    
      #all variables as predictors
    if(input$predvars == "all"){
      
      #Status Bar
      progress <- Progress$new(session, min=1, max=15)
      on.exit(progress$close())
      
      progress$set(message = 'Calculation in progress',
                   detail = 'This may take a while...')
      
      for (i in 1:15) {
        progress$set(value = i)
        Sys.sleep(0.5)
      }
      
      #Create train/test datsets
      #repeated cross validation
      set.seed(123)
      trCtrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
      #print(trCtrl)
      rfFit <- train(as.formula(paste(input$vars1,"~.")), data = dfTrain, method = "rf",
                     trControl = trCtrl, preProcess = c("center", "scale"), imp = TRUE)
    }else{
      
      if(is.null(input$vars2) == TRUE){
        print("Please select the predictor variables.")
      }
        
        else{
          #Status Bar
          progress <- Progress$new(session, min=1, max=15)
          on.exit(progress$close())
          
          progress$set(message = 'Calculation in progress',
                       detail = 'This may take a while...')
          
          for (i in 1:15) {
            progress$set(value = i)
            Sys.sleep(0.5)
          }
          
          #Create train/test datsets
          #repeated cross validation
          set.seed(123)
          trCtrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
          rfFit <- train(as.formula(paste(input$vars1," ~ ",paste(input$vars2,collapse="+"))), data = dfTrain, method = "rf",
                         trControl = trCtrl, preProcess = c("center", "scale"), imp = TRUE)
        }

    }
      
      #random forest output
      impt <- varImp(rfFit, scale = FALSE)
      list(result = rfFit, importance = impt, dfTest = dfTest)
  })

  
  
  #random forest button to run model
  rfModelEvent <- eventReactive(input$rfButton,{
    RandForest()
  })
  
  #Print Random Forest output
  output$rfOutput <- renderPrint({
    rfModelEvent()[1:2]
    
  })
  
  #variable importance plot from random forest model
  output$varImpPlot <- renderPlot({
    if (input$predvars == "all") {
      
      rfImp <- rfModelEvent()$importance
      plot(rfImp)
    }
    
    else{
      if((is.null(input$vars2) == TRUE)){
        print("Please select the predictor variables.")
      }
      
      else{
        rfImp <- rfModelEvent()$importance
        plot(rfImp)
      }
    }
  })
  
  #Table of predictions from random forest model
  output$rfPred <- renderTable({
    if (input$predvars == "all") {
      
      rfPred <- predict(rfModelEvent()$result, newdata = rfModelEvent()$dfTest)
      tbl_df(data.frame(rfPred, rfModelEvent()$dfTest))
    }
    
    else{
      if((is.null(input$vars2) == TRUE)){
        print("Please select the predictor variables.")
      }
      
      else{
        rfPred <- predict(rfModelEvent()$result, newdata = rfModelEvent()$dfTest)
        tbl_df(data.frame(rfPred, rfModelEvent()$dfTest))
      }
    }
  }, caption = "Random Forest Prediction and Test Data", caption.placement = "top" )
  
  
  #### Principal Component Analysis
  
  PC <- reactive({

  })
  
  #reactive variable for principal component analysis
  analysisPC <- reactive({
    data <- filterDataExplore() %>% filterStationYear(input$stationPC, input$yearPC) %>% filter(month == input$monthPC) %>% na.omit()
    data <- dplyr::select(data, vars)
    prcomp(data, center = TRUE, scale = TRUE)
  })
  
  #PC output
  output$outputPC <- renderPrint({
    eventPC()
  })
  
  #PC button
  eventPC <- eventReactive(input$PCbutton,{
      analysisPC()
  })
  
  #PC biplot
  output$biplot <- renderPlot({
    biplot(eventPC(), choices = input$xPC:input$yPC)
  })

  
  #scree plot
  output$screeplot <- renderPlot({
    screeplot(eventPC(), type = "lines")
  })

  
})
