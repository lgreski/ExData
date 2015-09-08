# plot5.R -- Exploratory Data Analysis project 2
# 
# author:  Len Greski
# date:    8 September 2015
# purpose: answer question 5 of 6
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

# question 6: Compare emissions from motor vehicle sources in Baltimore City 
#             with emissions from motor vehicle sources in Los Angeles County, 
#             California (fips == "06037"). Which city has seen greater changes 
#             over time in motor vehicle emissions?

## aggregate data by year across all measurements

vehicleSCC <- SCC[grep("Highway Veh",SCC$Short.Name),1]

vehicleSources <- NEI[NEI$SCC %in% vehicleSCC & (NEI$fips == "24510" | NEI$fips == "06037"), ] 
yearFactor <- factor(vehicleSources$year)
aggPM25 <- aggregate(Emissions ~ yearFactor + fips,data = vehicleSources, FUN = "sum")
baltimore <- aggPM25[aggPM25$fips == "24510",]
losAngeles <- aggPM25[aggPM25$fips == "06037",]
# generate bar plot
thePngFile <- png(file="plot6.png",width=480,height=480,units = "px")
par(mfrow = c(1,2))
barplot(baltimore$Emissions, names.arg=baltimore$yearFactor,
        xlab = "Year",
        ylab = "PM2.5 Emissions",
        main = "Baltimore PM2.5 Vehicle Emissions")
barplot(losAngeles$Emissions, names.arg=losAngeles$yearFactor,
        xlab = "Year",
        ylab = "PM2.5 Emissions",
        main = "Los Angeles PM2.5 Vehicle Emissions")
dev.off()