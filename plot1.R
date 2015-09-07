# File: plot1.r
# Author: Leonard Greski
# Course: ExData-032, Exploratory Data Analysis, Johns Hopkins University / Coursera
# 
# Date: 7 September 2015
# Revision history: revisions tracked on github.com
# 
# Purpose: draw histogram of Global Active Power

# check to see whether power consumption zip file exists on disk. If it is not present,
# download and unzip

if(!file.exists("power_consumption.zip")){
     url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
     download.file(url,destfile='power_consumption.zip',method="curl",mode="wb")
     unzip(zipfile = "power_consumption.zip")    
}

if (!"readr" %in% installed.packages()) {
     warning("Package readr required for this script. Installing readr now.")
     install.packages("readr")
}
library(readr)

theData <- read_csv2("household_power_consumption.txt",
                     col_names=TRUE,n_max=2075259,na = "?")
theSubset <- theData[theData$Date %in% c("1/2/2007","2/2/2007"), ]

# combine date and time into timestamp, so we can use on X axis for scatterplots
theSubset$dateTime <- strptime(paste(theSubset$Date,theSubset$Time),
                               format="%d/%m/%Y %H:%M:%S")

# plot 1: histogram of Global Active Power 
thePngFile <- png(file="plot1.png",width=480,height=480,units = "px")
hist(theSubset$Global_active_power,col="red",
     main="Global Active Power",
     xlab="Global Active Power (kilowatts)")
dev.off()