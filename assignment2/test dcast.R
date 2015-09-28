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

yearFactor <- factor(NEI$year)
typeFactor <- factor(NEI$type)
aggPM25 <- aggregate(Emissions ~ yearFactor + typeFactor,
data = NEI, FUN = "sum")

library(reshape2)
newFrame <- dcast(aggPM25, yearFactor ~ typeFactor)

# melt it back to aggregated form 
meltedFrame <- melt(newFrame,id.vars="yearFactor",
                    variable.name="type")

