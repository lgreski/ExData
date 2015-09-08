# plot3.R -- Exploratory Data Analysis project 2
# 
# author:  Len Greski
# date:    8 September 2015
# purpose: answer question 3 of 6
#
# check to see whether power consumption zip file exists on disk. If it is not present,
# download and unzip

if(!file.exists("pm25_emissions.zip")){
     url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
     download.file(url,destfile='pm25_emissions.zip',method="curl",mode="wb")
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
# generate TBD plot -- STOPPED HERE -- 
# thePngFile <- png(file="plot3.png",width=480,height=480,units = "px")
barplot(aggPM25$x, names.arg=aggPM25$Group.1,
        xlab = "Year",
        ylab = "Total PM2.5 Emissions",
        main = "Baltimore PM2.5 Emissions Across All Sources")
# dev.off()