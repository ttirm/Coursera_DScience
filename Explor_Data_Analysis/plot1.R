temp <- tempfile()
#Download the files
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp, mode="wb")
unzip(temp, overwrite = TRUE, exdir = "./data", junkpaths = TRUE)
#Read the files into the data frames
SCC <-readRDS("./data/Source_Classification_Code.rds")
NEI <-readRDS("./data/summarySCC_PM25.rds")

#Obtain the total emissions per year
s1 <- tapply(NEI$Emissions, NEI$year, sum, na.rm = TRUE)
sdata1 <- data.frame(year = as.numeric(names(s1)), total = s1)

#plot 1
png(file = "./plot1.png", bg = "transparent",width = 480, height = 480)
plot(sdata1$year,sdata1$total, type = "n" , xlab = "Year", ylab = "Total PM2.5 Emission", main = "Total Emissions in United States")
lines(sdata1$year,sdata1$total, lwd = 2)
dev.off()