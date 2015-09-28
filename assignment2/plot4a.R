# plot4.R -- Exploratory Data Analysis project 2
# 
# author:  Len Greski
# date:    8 September 2015
# purpose: answer question 4 of 6
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

# question 4: Across the United States, how have emissions
#             from coal combustion-related sources changed from 1999–2008?

## aggregate data by year across all measurements

# decided to pull any source that is related to coal, including charcoal production
# mining of coal, and residential charcoal burning, a total of 239 different sources  
coalSCC <- SCC[grep("[Cc]omb",SCC$Short.Name),1:3]
coalSCC <- SCC[grep("[Cc]oal",SCC$Short.Name),1]

coalSources <- NEI[NEI$SCC %in% coalSCC,]
yearFactor <- factor(coalSources$year)
aggPM25 <- aggregate(Emissions ~ yearFactor,data = coalSources, FUN = "sum")

# generate bar plot
thePngFile <- png(file="plot4.png",width=480,height=480,units = "px")
barplot(aggPM25$Emissions, names.arg=aggPM25$yearFactor,
        xlab = "Year",
        ylab = expression(PM[2.5] * " Emissions"),
        main = expression("United States " * PM[2.5] * " Coal Related Emissions"))
dev.off()