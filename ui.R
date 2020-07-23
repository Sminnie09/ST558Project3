#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
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
                             selectInput("station", "Select a city", selected = "Aotizhongxin", 
                                         choices = c("Aotizhongxin", "Changping", "Dingling")),
                             #selectizeInput("year", "Select a year", selected = "2013", 
                                            #choices = levels(as.factor(data$year))),
                             #selectizeInput("month", "Select a month", selected = "1", 
                               #             choices = levels(as.factor(data$month)))
            ),
            
            conditionalPanel(condition = "input.station != 'Aotizhongxin'",
                             selectInput("year", "Select a year", selected = "2013", 
                                            choices = levels(as.factor(data$year)))
            ),
            
            conditionalPanel(condition = "input.tabs == 'Data Exploration'",
                             selectInput("station", "City", selected = "Aotizhongxin", 
                                            choices = levels(as.factor(data$station))),
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
                    tabPanel("Data",DT::dataTableOutput("table")),
                    tabPanel("Data Exploration"),
                    tabPanel("Principal Component Analysis"),
                    tabPanel("Multiple Linear Regression"),
                    tabPanel("Random Forest")
        ))
    )
))

