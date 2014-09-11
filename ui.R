library(shiny)
library(XML)
library(RColorBrewer)
library(ggplot2)

source("getdata.R")

shinyUI(pageWithSidebar(
     
     headerPanel("UFO Reports in the US and Canada"),
     
     sidebarPanel(
          span("This app uses the last ten years of reported UFOs from the "),
          a("National UFO Reporting Center database", 
            href = "http://www.nuforc.org/webreports.html"),
          span(".  It allows the user to examine the data by UFO shape and look for trends in reporting over time."),
          br(),
          p(em("Documentation:",a("UFOs",href="readme.html"))),
          br(),
          selectInput("region", label = h3("Select a region"), 
                      choices = list("All","Northeast","West","South","Midwest","Canada"), selected = "All"),
          selectInput("shape", label = h3("Select a UFO shape"), 
                      choices = c("All", unique(cleanufos$Shape)), selected = "All")
     ),
     
     mainPanel(
          plotOutput('plot1'),
          br(),
          plotOutput('plot2')  
     )
))
