# plot5.R -- Exploratory Data Analysis project 2
# 
# author:  Len Greski
# date:    8 September 2015
# purpose: answer question 5 of 6
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

# question 5: How have emissions from motor vehicle sources changed
#             from 1999–2008 in Baltimore City?

## aggregate data by year across all measurements

# subset SCC to onroad / highway vehicles only, which excludes
# off road vehicles like ATVs, dirt bikes, and other off road recreational 
# equipment, a total of 1,137 sources
vehicleSCC <- SCC[grep("Highway Veh",SCC$Short.Name),1]
vehicleNames <- grep("Highway Veh",SCC$Short.Name,value = TRUE)

vehicleSources <- NEI[NEI$SCC %in% vehicleSCC & NEI$fips == "24510",]
yearFactor <- factor(vehicleSources$year)
aggPM25 <- aggregate(Emissions ~ yearFactor,data = vehicleSources, FUN = "sum")

# generate bar plot
thePngFile <- png(file="plot5.png",width=480,height=480,units = "px")
barplot(aggPM25$Emissions, names.arg=aggPM25$yearFactor,
        xlab = "Year",
        ylab = expression(PM[2.5] * " Emissions"),
        main = expression("Baltimore " * PM[2.5] * " Motor Vehicle Emissions"))
dev.off()