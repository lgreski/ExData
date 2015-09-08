# File: plot2.R
# Author: Leonard Greski
# Course: ExData-032, Exploratory Data Analysis, Johns Hopkins University / Coursera
# 
# Date: 7 September 2015
# Revision history: revisions tracked on github.com
# 
# Purpose: produce Line chart of Global Active Power
#    

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

# plot 2: line chart 
thePngFile <- png(file="plot2.png",width=480,height=480,units = "px")
with(theSubset, plot(dateTime, Global_active_power,type = "n",
                     ylab="Global Active Power (kilowatts)",
                     xlab=" "))
with(theSubset,lines(dateTime,Global_active_power))
dev.off()
