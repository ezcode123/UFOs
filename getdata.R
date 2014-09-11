# The following code can be used to load in the data from the web

#      dates <- c(seq(200401, 200412, by = 1), seq(200501, 200512, by = 1),
#                seq(200601, 200612, by = 1), seq(200701, 200712, by = 1),
#                seq(200801, 200812, by = 1), seq(200901, 200912, by = 1),
#                seq(201001, 201012, by = 1), seq(201101, 201112, by = 1),
#                seq(201201, 201212, by = 1), seq(201301, 201312, by = 1),
#                seq(201401, 201408, by = 1))
#      for (i in 1:length(dates)){
#           fileUrl <- paste("http://www.nuforc.org/webreports/ndxe", dates[i], ".html", sep="")
#           print(fileUrl)
#           table <- readHTMLTable(fileUrl, stringsAsFactors = FALSE)
#           ufodate <- data.frame(table[1], stringsAsFactors = FALSE)
#           names(ufodate) <- gsub("NULL.", "", names(ufodate))
#           if (i == 1) ufos <- ufodate else ufos <- rbind(ufos, ufodate)
#      }
#      
#      write.csv(ufos, file = "www/ufos.csv", row.names = FALSE)

# For expediency, the data was saved to a csv file and loaded to the server.

ufos <- read.csv("www/ufos.csv", stringsAsFactors = FALSE)

# Assign regions by state

where <- data.frame(state.abb, region = as.character(state.region), stringsAsFactors = FALSE)
others <- data.frame(state.abb = c("ON","BC","AB","SK","NB","QC","MB","NS","NF","YT","DC"), 
                     region = c(rep("Canada",10),"South"))
where <- rbind(where, others)
where$region <- ifelse(where$region == "North Central", "Midwest", 
                       where$region)
ufosByRegion <- merge(ufos, where, by.x = "State", by.y = "state.abb", all = FALSE)

# Clean up data for missing shapes and convert date to proper format

cleanufos <- ufosByRegion[!ufosByRegion$Shape == "",]
names(cleanufos)[names(cleanufos)=="Date...Time"] <- "Date"
cleanufos$Date <- as.Date(cleanufos$Date, "%m/%d/%y %H:%M")
cleanufos$Month <- format(cleanufos$Date, "%b")
cleanufos$Year <- as.numeric(format(cleanufos$Date, "%Y"))

mypalette <- c(brewer.pal(9,"Set1"), brewer.pal(12,"Set3"), brewer.pal(7,"Set2"))

# Overall summary for data by shape and region

sum12 <- aggregate(Posted ~ Shape + region, data = cleanufos, length)
