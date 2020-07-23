library(shiny)

source("S:/ST558/Homeworks/Project 3/ST558Project3/source.R")


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
                             #selectizeInput("year", "Select a year", selected = "2013", 
                                            #choices = levels(as.factor(data$year))),
                             #selectizeInput("month", "Select a month", selected = "1", 
                               #             choices = levels(as.factor(data$month)))
            ),
            
            conditionalPanel(condition = "input.station != 'Select a city'",
                             selectInput("year", "Select a year", selected = "Select a year", 
                                            choices = c("Select a year","2013", "2014", "2015", "2016", "2017"))
            ),
            
            conditionalPanel(condition = "input.tabs == 'Data Exploration'",
                             #selectInput("station", "City", selected = "Aotizhongxin", 
                               #             choices = levels(as.factor(data$station))),
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
                    tabPanel("Data Exploration"),
                    tabPanel("Principal Component Analysis"),
                    tabPanel("Regression"),
                    tabPanel("Random Forest")
        ))
    )
))

