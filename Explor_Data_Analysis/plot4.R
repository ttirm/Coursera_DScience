library(ggplot2)
library(reshape2)

temp <- tempfile()
#Download the files
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp, mode="wb")
unzip(temp, overwrite = TRUE, exdir = "./data", junkpaths = TRUE)
#Read the files into the data frames
SCC <-readRDS("./data/Source_Classification_Code.rds")
NEI <-readRDS("./data/summarySCC_PM25.rds")


# Select only the Coal Cobustion sources
cc <- SCC[grep("Comb (.*) Coal",SCC$Short.Name),"SCC"]
#Filter the data present in the previous selection
s4 <- subset(NEI, SCC %in% cc)
#Obtain the total emissions per year
st4 <- tapply(s4$Emissions, s4$year, sum)
sdata4 <- data.frame(year = as.numeric(names(st4)), total = st4)


#plot 4
png(file = "./plot4.png", bg = "transparent",width = 480, height = 480)
g <- ggplot(data = sdata4, aes(year,total))
g+geom_line(colour = "red" ) + geom_point(colour = "red")+xlab("Year")+ylab("Total PM2.5 Emission")+ggtitle("Total Emissions from Coal Combustion Sources Across United States")
dev.off()