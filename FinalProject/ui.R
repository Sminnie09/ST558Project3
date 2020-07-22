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
    sidebarLayout(
        
        # Sidebar panel for inputs 
        sidebarPanel(
            
            # Input: Select the random distribution type 
            radioButtons("dist", "Distribution type:",
                         c("Normal" = "norm",
                           "Uniform" = "unif",
                           "Log-normal" = "lnorm",
                           "Exponential" = "exp")),
            
            # br() element to introduce extra vertical spacing 
            br(),
            
            sliderInput("n",
                        "Number of observations:",
                        value = 500,
                        min = 1,
                        max = 1000)
            
        ),
    
    # Tabs
    mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Information"),
                    tabPanel("Data"),
                    tabPanel("Data Exploration"),
                    tabPanel("Principal Component Analysis"),
                    tabPanel("Modeling")
        )  
            

        
    )
)
))
