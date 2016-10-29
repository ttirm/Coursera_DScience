library(ggplot2)
library(reshape2)

temp <- tempfile()
#Download the files
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp, mode="wb")
unzip(temp, overwrite = TRUE, exdir = "./data", junkpaths = TRUE)
#Read the files into the data frames
SCC <-readRDS("./data/Source_Classification_Code.rds")
NEI <-readRDS("./data/summarySCC_PM25.rds")


#Transform the type as a factor
nei_bc$type <- as.factor(nei_bc$type)
#Obtain the total emissions per year
s3 <- tapply(nei_bc$Emissions, list(nei_bc$year, nei_bc$t), sum, na.rm = TRUE)
sdata3 <- data.frame(year = as.numeric(rownames(s3)), s3)
sdata3 <- melt(sdata3, id.Vars = c("year"), measure.vars = c("NON.ROAD","NONPOINT","ON.ROAD", "POINT"))



#plot 3
png(file = "./plot3.png", bg = "transparent",width = 480, height = 480)
g <- ggplot(data = sdata3, aes(year,value))
g+geom_line()+facet_grid(.~variable)+geom_smooth(method = "lm")+xlab("Year")+ylab("Total PM2.5 Emission")+ggtitle("Total Emissions in Baltimore City per Type")
dev.off()