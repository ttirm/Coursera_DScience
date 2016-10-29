temp <- tempfile()
#Download the files
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp, mode="wb")
unzip(temp, overwrite = TRUE, exdir = "./data", junkpaths = TRUE)
#Read the files into the data frames
SCC <-readRDS("./data/Source_Classification_Code.rds")
NEI <-readRDS("./data/summarySCC_PM25.rds")

#extract the Baltimore City data
nei_bc <- subset(NEI, NEI$fips == "24510")
#Obtain the total emissions per year
s2 <- tapply(nei_bc$Emissions, nei_bc$year, sum, na.rm = TRUE)
sdata2 <- data.frame(year = as.numeric(names(s2)), total = s2)

#plot 2
png(file = "./plot2.png", bg = "transparent",width = 480, height = 480)
plot(sdata2$year,sdata2$total, type = "n" , xlab = "Year", ylab = "Total PM2.5 Emission", main = "Total Emissions in Baltimore City")
lines(sdata2$year,sdata2$total, lwd = 2)
dev.off()