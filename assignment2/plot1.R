# plot1.R -- Exploratory Data Analysis project 2
# 
# author:  Len Greski
# date:    8 September 2015
# purpose: answer question 1 of 6
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

## question 1: Have total emissions from PM2.5 decreased in the United States from 
##             1999 to 2008? Using the base plotting system, make a plot showing the total 
##             PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

## aggregate data by year across all measurements
yearFactor <- factor(NEI$year)
aggPM25 <- aggregate(x = NEI$Emissions,by = list(yearFactor), FUN = "sum")

# generate bar plot
barplot(aggPM25$x, names.arg=aggPM25$Group.1,
        xlab = "Year",
        ylab = "Total PM2.5 Emissions",
        main = "United States PM2.5 Emissions Across All Sources")
