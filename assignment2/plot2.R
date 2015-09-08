# plot2.R -- Exploratory Data Analysis project 2
# 
# author:  Len Greski
# date:    8 September 2015
# purpose: answer question 2 of 6
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

## question 2: Have total emissions from PM2.5 decreased in the Baltimore City, 
##             Maryland (fips == "24510") from 1999 to 2008? 
##             Use the base plotting system to make a plot answering this question.

## aggregate data by year across all measurements
baltimore <- NEI[NEI$fips == "24510",]
yearFactor <- factor(baltimore$year)
aggPM25 <- aggregate(Emissions ~ yearFactor, data=baltimore, FUN = "sum")

# generate bar plot
thePngFile <- png(file="plot2.png",width=480,height=480,units = "px")
barplot(aggPM25$Emissions, names.arg=aggPM25$yearFactor,
        xlab = "Year",
        ylab = "Total PM2.5 Emissions",
        main = "Baltimore PM2.5 Emissions - All Sources")
dev.off()