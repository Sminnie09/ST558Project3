library(shiny)
library(plotly)

source("global.R")

shinyUI(fluidPage(
    
    # Tabs
        navbarPage("ST558 Final Project",
                    tabPanel("Information",
                             sidebarLayout(
                                 sidebarPanel(
                                     strong(h1("Outline of App Abilities", align = "center")),
                                     h3("Data"),
                                     p("- View the full dataset and subsets of the data. Save data
                                       as csv file."),
                                     h3("Data Exploration"),
                                     p("- Explore subsets of the dataset and save as png file"),
                                     h4("Graphical Summaries"),
                                     p(" - Boxplots of each pollutant. Histograms of each pollutant with the
                                       ability to change the number of bins and download image as png."),
                                     h4("Numerical Summaries"),
                                     p(" - Five number summary for pollutant and meteorological variables
                                       in the dataset. View subsets of data and ability to change the number of observations
                                       shown in the data table."),
                                     h3("Principal Component Analysis"),
                                     p(" - Select a subset of data and click Run Analysis button. The results of the analysis
                                     for all pollutants and meteorological variables will output along with a variance plot
                                     and biplot. Ability to select orthogonal principal components to change the biplot for  
                                     the analysis run."),
                                     h3("Supervised Learning Models"),
                                     p(" - Explore the response of Pollutant and meteorological variables as predictors."),
                                     h4("Regression Model"),
                                     p(" - Select a subset of data, a predictor variable, and a response variable to view scatter
                                       plot. Check the check box to view summary of simple linear regression model. View the
                                       test dataset and response prediction. The following equation was used to create the model:"),
                                     uiOutput("SLR"),
                                     h4("Random Forest Model")
                                     
                                 ),
                                 mainPanel(
                                     h1("Data Information", align = "center"),
                                     
                                     
                                 )
                             )
                    ),
                    tabPanel("Data", fluid = TRUE,
                             sidebarLayout(
                               sidebarPanel(
                                    h3("View Datasets"),
                                    selectInput("station", "Select a city", selected = 'Aotizhongxin', 
                                                              choices = levels(as.factor(loadData()$station))),
                                    selectInput("year", "Select a year", selected = "2013", 
                                                              choices = levels(as.factor(loadData()$year))),
                                    selectInput("month", "Select a month", selected = '3', 
                                                choices = levels(as.factor(loadData()$month))),
                                    checkboxInput("Alldata", h6("Show all data"), FALSE)
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
                                     numericInput("obs", "Number of Observations to view", value = 10)
                                   ),
                                   mainPanel(
                                     verbatimTextOutput("numSummary"),
                                      tableOutput("view"),
                                     tableOutput("sumTable")
                                   )
                                 )
                               )
                            ),
                              tabPanel("Principal Component Analysis", fluid = TRUE,
                                       sidebarLayout(
                                           sidebarPanel(
                                               headerPanel("Choose a dataset"),
                                               selectInput("stationPC", "Select a city", selected = 'Aotizhongxin', 
                                                           choices = levels(as.factor(loadData()$station))),
                                               selectInput("yearPC", "Select a year", selected = "2013", 
                                                           choices = levels(as.factor(loadData()$year))),
                                               selectInput("monthPC", "Select a month", selected = '3', 
                                                           choices = levels(as.factor(loadData()$month))),
                                               h3("Select Principal Components"),
                                               selectInput("xPC", "Select PC for x-axis", choices = seq(1:10), selected = 1),
                                               selectInput("yPC", "Select PC for yaxis", choices = seq(1:10), selected = 2),
                                               actionButton('PCbutton', label = 'Run Analysis'),
                                               plotOutput("biplot")
                                           ),
                                           mainPanel(
                                               verbatimTextOutput("outputPC"),
                                               plotOutput("screeplot")
                                               
                                           )
                                       )
                            ),
                   navbarMenu("Supervised Learning Models", 
                              tabPanel("Regression Model", fluid = TRUE,
                                       sidebarLayout(
                                         sidebarPanel(
                                           h3("Regression Model"),
                                           selectInput("stationReg", "Select a city", selected = 'Aotizhongxin', 
                                                       choices = levels(as.factor(loadData()$station))),
                                           selectInput("yearReg", "Select a year", selected = "2013", 
                                                       choices = levels(as.factor(loadData()$year))),
                                           selectInput("xcol", "Predictor Variable (x)", selected = "PM2.5",
                                                       choices = pols),
                                           selectInput("ycol", "Response Variable", selected = "PM10",
                                                       choices = pols),
                                           sliderInput("monthReg", label = "Month", value = 6, min = 1,
                                                       max = 12),
                                           checkboxInput("regEqu", h4("Fit Regression Equation?"), FALSE)
                                         ),
                                         mainPanel(
                                           plotlyOutput("regressionPlot"),
                                           
                                           verbatimTextOutput("regressionEqu"),
                                           DT::dataTableOutput("regTable")
                                         ),
                                       ),
                              ),
                              tabPanel("Random Forest Model", fluid = TRUE,
                                       sidebarLayout(
                                         sidebarPanel(
                                           h2("Random Forest Model"),
                                           h3("Choose a Dataset"),
                                           selectInput("stationRF", "Select a city", selected = 'Aotizhongxin', 
                                                       choices = levels(as.factor(loadData()$station))),
                                           selectInput("yearRF", "Select a year", selected = "2013", 
                                                       choices = levels(as.factor(loadData()$year))),
                                           selectInput("monthRF", "Select a month", selected = '3', 
                                                       choices = levels(as.factor(loadData()$month))),
                                           selectInput("dayRF", "Select a day", selected = '1',
                                                       choices = levels(as.factor(loadData()$day))),
                                           h3("Choose Model Parameters"),
                                           selectInput("vars1", "Select one outcome variable:", choices = pols, selected = "PM2.5", multiple = FALSE),
                                           radioButtons("predvars", "Choose predictor variables:",
                                                        list("All" = "all", "Select predictor variables" = "select"), selected = NULL),
                                           conditionalPanel(condition = "input.predvars == 'select'",
                                                            selectInput("vars2", "Select the predictor variables:", choices = vars, selected = NULL, multiple=TRUE)          
                                           ),
                                           actionButton('rfButton', label = 'Run Model'),
                                           plotOutput("varImpPlot")
                                          
                                           
                                           
                                           
                                         ),
                                         mainPanel(
                                           verbatimTextOutput("rfOutput"),
                                           tableOutput("rfPred")
                                           
                                         )
                                       )
                              )
                   )

                
        )
    )
)



