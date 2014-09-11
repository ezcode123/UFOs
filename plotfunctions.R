
f.barall <- function(dataset){
     bar1 <- ggplot(dataset, aes(x=region, y=Posted)) 
     bar1 <- bar1 + geom_bar(stat = "identity", aes(fill = factor(Shape)))
     bar1 <- bar1 + scale_fill_manual(values=mypalette, name = "UFO Shape")
     bar1 <- bar1 + theme_bw() + labs(title="UFO Reports by Region and Shape \n")
     bar1 <- bar1 + xlab(label = "Region") + ylab(label = "Number Reported")
     print(bar1)
}

f.barregion <- function(dataset){
     bar2 <- ggplot(sum13, aes(x=Shape, y=Posted)) 
     bar2 <- bar2 + geom_bar(stat = "identity", aes(fill = factor(Shape)))
     bar2 <- bar2 + scale_fill_manual(values=mypalette, name = "UFO Shape")
     bar2 <- bar2 + theme_bw() + coord_flip()  + labs(title=paste("UFO Reports Shape in Region: ", lab, "\n")) 
     bar2 <- bar2 + xlab(label = "UFO Shape") + ylab(label = "Number Reported")
     print(bar2)
}