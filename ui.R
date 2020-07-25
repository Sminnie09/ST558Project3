library(shiny)
library(plotly)



shinyUI(fluidPage(

    # Application title
    #titlePanel("Final Project"),
    
    # Tabs
        navbarPage("ST558 Final Project",
                    tabPanel("Information"),
                    tabPanel("Data", fluid = TRUE,
                             sidebarLayout(
                               sidebarPanel(
                                                  selectInput("station", "Select a city", selected = 'Select a city', 
                                                              choices = c("Select a city","Aotizhongxin", "Changping", "Dingling")),
                                 #conditionalPanel(condition = "input.station != 'Select a city'",
                                                  selectInput("year", "Select a year", selected = "Select a year", 
                                                              choices = c("Select a year","2013", "2014", "2015", "2016", "2017"))
                                 #)
                               ),
                               mainPanel(
                                 DT::dataTableOutput("table"), downloadButton("download1","Download as csv"))
                               )
                             ),
                    navbarMenu("Data Exploration",
                               tabPanel("Graphical Summaries", fluid = TRUE,
                                       sidebarLayout(
                                         sidebarPanel(
                                           selectInput("stationPlot", "Select a city", selected = 'Aotizhongxin', 
                                                       choices = c("Aotizhongxin", "Changping", "Dingling")),
                                           selectInput("yearPlot", "Select a year", selected = "2013", 
                                                       choices = c("2013", "2014", "2015", "2016", "2017")),
                                           selectInput("plot", "Plot Type", selected = 'Boxplot', 
                                                       choices = c("Boxplot", "Histogram")),
                                           conditionalPanel(condition = "input.plot == 'Boxplot'",
                                                            #downloadButton("downloadBox","Download as png")
                                           ),
                                           conditionalPanel(condition = "input.plot == 'Histogram'",
                                                            selectInput("pollutant", "Select a Pollutant", selected = "PM2.5", 
                                                                        choices = c("PM2.5", "PM10","SO2","NO2","CO","O3")),
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
                                     selectInput("stationSum", "Select a city", selected = 'Aotizhongxin', 
                                                 choices = c("Aotizhongxin", "Changping", "Dingling")),
                                     selectInput("yearSum", "Select a year", selected = "2013", 
                                                 choices = c("2013", "2014", "2015", "2016", "2017")),
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
                            # sidebarLayout(
                             #  sidebarPanel(
                                                  #selectInput("summaries", "Select a Summary", selected = "Select a Summary",
                                                   #           choices = c("Select a Summary", "Numerical", "Graphical")),
                                   #checkboxInput("Graphical", h5("Graphical Summary"), FALSE),
                                   #checkboxInput("Numerical", h5("Numerical Summary"), TRUE),
                              #   conditionalPanel(condition = "input.Graphical == true",
                                #                  selectInput("plot", "Plot Type", selected = 'Select a plot type', 
                                 #                             choices = c("Select a plot type", "Boxplot", "Histogram"))
                               #  ),
                                 #conditionalPanel(condition = "input.plot == 'Boxplot'",
                                  #                downloadButton("downloadBox","Download as png")
                                   #               ),
                                 #conditionalPanel(condition = "input.plot == 'Histogram'",
                                  #                selectInput("pollutant", "Select a Pollutant", selected = "PM2.5", 
                                   #                           choices = c("PM2.5", "PM10","SO2","NO2","CO","O3")),
                                    #              sliderInput("bins", label = "Number of Bins", value = 10, min = 1,
                                     #                         max = 50),
                                      #            downloadButton("downloadHist","Download as png")
                               #),
                               #conditionalPanel("input.Numerical == true",
                                #        numericInput("obs", "Number of Observations to view", value = 10)
                                 #               )
                             #),
                             #mainPanel(
                              #   conditionalPanel(condition = "input.Graphical == true",
                               #     plotOutput("plot")
                                # ),
                            #   conditionalPanel("input.Numerical == true",
                             #       verbatimTextOutput("numSummary"),
                              #      tableOutput("view")
                               #),
                             #)
                             #),
                    #),
                    tabPanel("Principal Component Analysis"),
                    tabPanel("Regression", fluid = TRUE,
                             sidebarLayout(
                                 sidebarPanel(
                                     selectInput("xcol", "Explanatory Variable (x)", selected = "PM2.5",
                                                 choices = c("PM2.5", "PM10","SO2","NO2","CO","O3","TEMP", "PRES", "DEWP", "WSPM")),
                                     selectInput("ycol", "Response Variable", selected = "O3",
                                                choices = c("O3", "SO2", "NO2", "PM2.5")),
                                     sliderInput("month", label = "Month", value = 6, min = 1,
                                                 max = 12),
                                     checkboxInput("regEqu", h4("Fit Regression Equation?"), FALSE)
                                     ),
                                 mainPanel(
                                     h3("Station: Dingling Data in 2016"),
                                     plotlyOutput("regression")
                                 ),
                             ),
                             ),
                    tabPanel("Random Forest")
                
        )
    )
)



