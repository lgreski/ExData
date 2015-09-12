# plot3.R -- Exploratory Data Analysis project 2
# 
# author:  Len Greski
# date:    8 September 2015
# purpose: answer question 3 of 6
#
# check to see whether power consumption zip file exists on disk. If it is not present,
# download and unzip

if(!file.exists("pm25_emissions.zip")){
     # since download.file is OS specific, check the OS and either set to wininet for windows
     # or curl for everything else
     dlMethod <- "curl"
     if(substr(Sys.getenv("OS"),1,7) == "Windows") dlMethod <- "wininet"
     url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
     download.file(url,destfile='pm25_emissions.zip',method=dlMethod,mode="wb")
     unzip(zipfile = "pm25_emissions.zip")    
}

# Expect to read this in 20 seconds on i5 processor machine
NEI <- readRDS("summarySCC_PM25.rds")

# Expect to read this in less than a second 
SCC <- readRDS("Source_Classification_Code.rds")

# question 3: Of the four types of sources indicated by the type (point, 
#             nonpoint, onroad, nonroad) variable, which of these four sources 
#             have seen decreases in emissions from 1999–2008 for Baltimore City? 
#             Which have seen increases in emissions from 1999–2008? Use the ggplot2 
#             plotting system to make a plot answer this question.

## aggregate data by year across all measurements
baltimore <- NEI[NEI$fips == "24510",]
yearFactor <- factor(baltimore$year)
typeFactor <- factor(baltimore$type)
aggPM25 <- aggregate(Emissions ~ yearFactor + typeFactor,
                     data = baltimore, FUN = "sum")
library(ggplot2)

thePngFile <- png(file="plot3.png",width=480,height=480,units = "px")
g <- ggplot(aggPM25, aes(x=yearFactor, y=Emissions,
                         ymin=0, ymax=2500)) + geom_bar(stat="identity")
g + facet_grid(. ~typeFactor) + labs(x = "Year") + 
     labs(y = expression("Total " * PM[2.5] * " Emissions")) +
     labs(title = expression("Baltimore City " * PM[2.5] * " Emissions by Source"))
dev.off()