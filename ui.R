library(shiny)

#source("S:/ST558/Homeworks/Project 3/ST558Project3/source.R", local = FALSE)


shinyUI(fluidPage(

    # Application title
    titlePanel("Final Project"),
    
    # Sidebar layout 
    sidebarLayout(position = "left",
      sidebarPanel(
        
            conditionalPanel(condition = "input.tabs == 'Information'",
                         #selectizeInput("station", "Select a city", selected = "Aotizhongxin", 
                          #              choices = levels(as.factor(data$station)))
            ),
            conditionalPanel(condition = "input.tabs == 'Data'",
                             selectInput("station", "Select a city", selected = 'Select a city', 
                                         choices = c("Select a city","Aotizhongxin", "Changping", "Dingling")),
            ),
            
                            conditionalPanel(condition = "input.station != 'Select a city'",
                                        selectInput("year", "Select a year", selected = "Select a year", 
                                            choices = c("Select a year","2013", "2014", "2015", "2016", "2017"))
                            ),
            
            conditionalPanel(condition = "input.tabs == 'Data Exploration'",
                             selectInput("summaries", "Select a Summary", selected = "Select a Summary",
                                         choices = c("Select a Summary", "Numerical", "Graphical"))
            ),
                      conditionalPanel(condition = "input.summaries == 'Graphical'",
                                       selectInput("plot", "Plot Type", selected = 'Select a Plot Type', 
                                                   choices = c("Select a Plot Type", "Boxplot", "Histogram")),
                                     #selectInput("station", "Select a city", selected = 'Select a city', 
                                      #           choices = c("Select a city","Aotizhongxin", "Changping", "Dingling")),
                                     #selectInput("year", "Select a year", selected = "Select a year", 
                                      #           choices = c("Select a year","2013", "2014", "2015", "2016", "2017")),
                                     ),
            conditionalPanel(condition = "input.plot == 'Boxplot'"),
                                conditionalPanel(condition = "input.plot == 'Histogram'",
                                                 selectInput("pollutant", "Select a Pollutant", selected = "Select a Pollutant", 
                                                             choices = c("Select a Pollutant","PM2.5", "PM10","SO2","NO2","CO","O3")),
                                                 sliderInput("bins", label = "Number of Bins", value = 10, min = 1,
                                                             max = 50)
                                                 ),

            conditionalPanel(condition = "input.tabs == 'Principal Component Analysis'",
                             #selectizeInput("station", "City", selected = "Aotizhongxin", 
                              #              choices = levels(as.factor(data$station)))
            ),
            conditionalPanel(condition = "input.tabs == 'Multiple Linear Regression'",
                             #selectizeInput("station", "City", selected = "Aotizhongxin", 
                              #              choices = levels(as.factor(data$station)))
            ),
            conditionalPanel(condition = "input.tabs == 'Random Forest'",
                             #selectizeInput("station", "City", selected = "Aotizhongxin", 
                                       #     choices = levels(as.factor(data$station)))
            ),
            
            br(),
        ),
    
    # Tabs
    mainPanel(
        tabsetPanel(id = "tabs",
                    tabPanel("Information"),
                    tabPanel("Data",DT::dataTableOutput("table"), downloadButton("download1","Download as csv")),
                    tabPanel("Data Exploration", plotOutput("plot")),
                    tabPanel("Principal Component Analysis"),
                    tabPanel("Regression"),
                    tabPanel("Random Forest")
        ))
    )
))

