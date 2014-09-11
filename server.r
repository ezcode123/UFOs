library(shiny)
library(XML)
library(RColorBrewer)
library(ggplot2)

shinyServer(function(input, output) {
     
     output$plot1 <- renderPlot(function() {
               if(input$region == "All") {
                    
                    bar1 <- ggplot(sum12, aes(x=region, y=Posted)) 
                    bar1 <- bar1 + geom_bar(stat = "identity", aes(fill = factor(Shape)))
                    bar1 <- bar1 + scale_fill_manual(values=mypalette, name = "UFO Shape")
                    bar1 <- bar1 + theme_bw() + labs(title="UFO Reports by Region and Shape \n")
                    bar1 <- bar1 + theme(plot.title = element_text(size=rel(1.5), face="bold", vjust=1, color = "blue"))
                    bar1 <- bar1 + xlab(label = "Region") + ylab(label = "Number Reported")
                    print(bar1)
                    
               } else {
                    
                    sum13 <- aggregate(Posted ~ Shape, data = cleanufos[cleanufos$region == input$region,], length)
                    bar2 <- ggplot(sum13, aes(x=Shape, y=Posted)) 
                    bar2 <- bar2 + geom_bar(stat = "identity", aes(fill = factor(Shape))) + theme_bw() 
                    bar2 <- bar2 + theme(plot.title = element_text(size=rel(1.5), face="bold", vjust=1, color = "blue"))
                    bar2 <- bar2 + scale_fill_manual(values=mypalette, name = "UFO Shape")
                    bar2 <- bar2 + coord_flip()  + labs(title=paste("UFO Reports by Shape in Region: ", input$region, "\n")) 
                    bar2 <- bar2 + xlab(label = "UFO Shape") + ylab(label = "Number Reported")
                    print(bar2)
                    
               }
          
     }, width=600, height = "auto")

     
     dataInput <- reactive({
                   if(input$region == "All") {
                        if(input$shape == "All"){
                             aggregate(Posted ~ Year, data = cleanufos, length)
                        } else {
                             aggregate(Posted ~ Year, data = cleanufos[cleanufos$Shape == input$shape,], length)
                        }
                
                    } else {
                        if(input$shape == "All"){
                             aggregate(Posted ~ Year, data = cleanufos[cleanufos$region == input$region,], length)
                        } else {
                             aggregate(Posted ~ Year, data = cleanufos[cleanufos$region == input$region & cleanufos$Shape == input$shape,], length)
                        }
                    }          
     })
     
    
     output$plot2 <- renderPlot(function() {  
          pdata <- dataInput()
          fit <- lm(Posted ~ Year, data = pdata)
          scatt <- ggplot(pdata, aes(x = Year, y = Posted))
          scatt <- scatt + geom_point(shape = 17,  size = 5, col = "magenta") + theme_bw()+ theme(legend.position = "none")
          scatt <- scatt + theme(plot.title = element_text(size=rel(1.5), face="bold", vjust=1, color = "blue"))
          scatt <- scatt + geom_smooth(method = lm, se = FALSE)
          scatt <- scatt + labs(title=paste("UFO Reports by Year in Region: ", input$region, "\n", "For Shape ", input$shape, "\n",
                                            "Slope = ", round(fit$coeff[2], 2), "; p-value =", round(summary(fit)$coeff[2,4], 5), "\n", sep = "")) 
          print(scatt)
     }, width=500, height = "auto")

     })
