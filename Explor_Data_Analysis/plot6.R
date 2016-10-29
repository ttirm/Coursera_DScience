library(ggplot2)
library(reshape2)

temp <- tempfile()
#Download the files
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp, mode="wb")
unzip(temp, overwrite = TRUE, exdir = "./data", junkpaths = TRUE)
#Read the files into the data frames
SCC <-readRDS("./data/Source_Classification_Code.rds")
NEI <-readRDS("./data/summarySCC_PM25.rds")


#extract the Baltimore and Los Angeles data
nei_bc <- subset(NEI, NEI$fips == "24510")
nei_la <- subset(NEI, NEI$fips == "06037")
# Select only the Motor Vehicle sources
mv <- SCC[grep("[Mm]otor",SCC$Short.Name),"SCC"]
#Filter the data present in the previous selection
s5 <- subset(nei_bc, SCC %in% mv)
s6 <- subset(nei_la, SCC %in% mv)
#Obtain the total emissions per year
st5 <- tapply(s5$Emissions, s5$year, sum)
sdata5 <- data.frame(year = as.numeric(names(st5)), total = st5, County = "Baltimore City")
st6 <- tapply(s6$Emissions, s6$year, sum)
sdata6<- data.frame(year = as.numeric(names(st6)), total = st6, County = "Los Angeles")
dt <- rbind(sdata5, sdata6)


#plot 6
png(file = "./plot6.png", bg = "transparent",width = 480, height = 480)
g <- ggplot(data = dt, aes(year,total,colour = County ) )
g+geom_line()+xlab("Year")+ylab("Total PM2.5 Emission")+ggtitle("Total Emissions from Motor Vehicle Sources in Baltimore and Los Angeles")
dev.off()