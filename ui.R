library(shiny)
library(plotly)

source("global.R")

shinyUI(fluidPage(
    
    # Tabs
        navbarPage("ST558 Final Project",
                    tabPanel("Information"),
                    tabPanel("Data", fluid = TRUE,
                             sidebarLayout(
                               sidebarPanel(
                                    h3("View Datasets"),
                                    selectInput("station", "Select a city", selected = 'Aotizhongxin', 
                                                              choices = levels(as.factor(loadData()$station))),
                                                  selectInput("year", "Select a year", selected = "2013", 
                                                              choices = levels(as.factor(loadData()$year)))
                               ),
                               mainPanel(
                                 DT::dataTableOutput("table"), downloadButton("download1","Download as csv"))
                               )
                             ),
                    navbarMenu("Data Exploration",
                               tabPanel("Graphical Summaries", fluid = TRUE,
                                       sidebarLayout(
                                         sidebarPanel(
                                           h3("Graphical Summaries"),
                                           selectInput("stationPlot", "Select a city", selected = 'Aotizhongxin', 
                                                       choices = levels(as.factor(loadData()$station))),
                                           selectInput("yearPlot", "Select a year", selected = "2013", 
                                                       choices =levels(as.factor(loadData()$year))),
                                           selectInput("plot", "Plot Type", selected = 'Boxplot', 
                                                       choices = c("Boxplot", "Histogram")),
                                           conditionalPanel(condition = "input.plot == 'Boxplot'",
                                                            #downloadButton("downloadBox","Download as png")
                                           ),
                                           conditionalPanel(condition = "input.plot == 'Histogram'",
                                                            selectInput("pollutant", "Select a Pollutant", selected = "PM2.5", 
                                                                        choices = pols),
                                                            sliderInput("bins", label = "Number of Bins", value = 10, min = 1,
                                                                        max = 50),
                                                            downloadButton("downloadHist","Download as png")
                                           )
                                         ),
                                         mainPanel(
                                           plotOutput("plot")
                                         )
                                       ) 
                                  ),
                               tabPanel("Numerical Summaries", fluid = TRUE,
                                 sidebarLayout(
                                   sidebarPanel(
                                     h3("Numerical Summaries"),
                                     selectInput("stationSum", "Select a city", selected = 'Aotizhongxin', 
                                                 choices = levels(as.factor(loadData()$station))),
                                     selectInput("yearSum", "Select a year", selected = "2013", 
                                                 choices = levels(as.factor(loadData()$year))),
                                     numericInput("obs", "Number of Observations to view", value = 10),
                                     textOutput("text")
                                   ),
                                   mainPanel(
                                     verbatimTextOutput("numSummary"),
                                      tableOutput("view")
                                   )
                                 )
                               )
                            ),
                              tabPanel("Principal Component Analysis"),
                   navbarMenu("Supervised Learning Models", 
                              tabPanel("Regression", fluid = TRUE,
                                       sidebarLayout(
                                         sidebarPanel(
                                           h3("Regression Analysis"),
                                           selectInput("stationReg", "Select a city", selected = 'Aotizhongxin', 
                                                       choices = levels(as.factor(loadData()$station))),
                                           selectInput("yearReg", "Select a year", selected = "2013", 
                                                       choices = levels(as.factor(loadData()$year))),
                                           selectInput("xcol", "Predictor Variable (x)", selected = "PM2.5",
                                                       choices = vars),
                                           selectInput("ycol", "Response Variable", selected = "O3",
                                                       choices = pols),
                                           sliderInput("month", label = "Month", value = 6, min = 1,
                                                       max = 12),
                                           checkboxInput("regEqu", h4("Fit Regression Equation?"), FALSE)
                                         ),
                                         mainPanel(
                                           plotlyOutput("regression"),
                                           
                                           verbatimTextOutput("regressionEqu"),
                                           tableOutput("regTable")
                                         ),
                                       ),
                              ),
                              tabPanel("Random Forest Model", fluid = TRUE,
                                       sidebarLayout(
                                         sidebarPanel(
                                           h3("Choose a Dataset"),
                                           selectInput("stationRF", "Select a city", selected = 'Aotizhongxin', 
                                                       choices = levels(as.factor(loadData()$station))),
                                           selectInput("yearRF", "Select a year", selected = "2013", 
                                                       choices = levels(as.factor(loadData()$year))),
                                           h3("Choose Model Parameters"),
                                           selectInput("vars1", "Select one outcome variable:", choices = pols, selected = vars[1], multiple = FALSE),
                                           radioButtons("predvars", "Choose predictor variables:",
                                                        list("All" = "all", "Select predictor variables" = "select"), selected = NULL),
                                           conditionalPanel(condition = "input.predvars == 'select'",
                                                            selectInput("vars2", "Select the predictor variables:", choices = vars, selected = NULL, multiple=TRUE)          
                                           ),
                                           actionButton('rfModel', 'Run Model')
                                          
                                           
                                           
                                           
                                         ),
                                         mainPanel(
                                           verbatimTextOutput("rfOutput")
                                         )
                                       )
                              )
                   )

                
        )
    )
)



