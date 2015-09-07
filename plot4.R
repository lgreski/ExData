# File: plot4.R
# Author: Leonard Greski
# Course: ExData-032, Exploratory Data Analysis, Johns Hopkins University / Coursera
# 
# Date: 7 September 2015
# Revision history: revisions tracked on github.com
# 
# Purpose: generate four plots on a single image, including 
#          upper left:  datetime * Global active power
#          upper right: datetime * Voltage
#          lower left:  datetime * Engergy sub metering
#          lower right: datetime * Global reactive power

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


# plot 4: multiple charts to the page
# set up rows and cols
thePngFile <- png(file="plot4.png",width=480,height=480,units = "px")

# important to set the mfrow parameter AFTER directing output to PNG file, or new
# device saves only the last chart 
par(mfrow = c(2,2))
with(theSubset, {
     ## upper left
     plot(dateTime, Global_active_power,type = "n",
                          ylab="Global Active Power",
                          xlab=" ")
     lines(dateTime,Global_active_power)
     ## upper right
     plot(dateTime, Voltage,type = "n",
                          ylab="Voltage",
                          xlab=" ")
     lines(dateTime,Voltage)
     ## lower left 
     plot(dateTime,Sub_metering_1, type = "n",
                         ylab = "Energy sub metering",
                         xlab = " ")
     lines(dateTime,Sub_metering_1,col = "black")
     lines(dateTime,Sub_metering_2,col = "red")
     lines(dateTime,Sub_metering_3,col = "blue")
     legend("topright",lty="solid",col=c("black","red","blue"),
            legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
     ## lower right
     plot(dateTime, Global_reactive_power,type = "n",
                          ylab="Global_reactive_power",
                          xlab="datetime")
     lines(dateTime,Global_reactive_power)
})
dev.off()