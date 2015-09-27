# plot1.R -- Exploratory Data Analysis project 2
# 
# author:  Len Greski
# date:    8 September 2015
# purpose: answer question 1 of 6
#
# codebook for NEI is located at http://www3.epa.gov/ttn/chief/net/2008neiv3/2008_neiv3_tsd_draft.pdf 
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

## question 1: Have total emissions from PM2.5 decreased in the United States from 
##             1999 to 2008? Using the base plotting system, make a plot showing the total 
##             PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

## aggregate data by year across all measurements
yearFactor <- factor(NEI$year)
aggPM25 <- aggregate(x = NEI$Emissions,by = list(yearFactor), FUN = "sum")

# generate bar plot
thePngFile <- png(file="plot1.png",width=480,height=480,units = "px")
barplot(aggPM25$x, names.arg=aggPM25$Group.1,
        xlab = "Year",
        ylab = expression("Total " * PM[2.5] * " Emissions"),
        main = expression("United States " * PM[2.5] * " Emissions: All Sources"))
dev.off()