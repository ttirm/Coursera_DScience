getwd()
setwd("C:/Users/tiago_000/Documents//GitHub/R_progamming")
if(!file.exists("data_cleaning")){
    dir.create("data_cleaning")
}
library(dplyr)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data_cleaning/Idaho.csv")
idaho <-read.csv("./data_cleaning/Idaho.csv")
idaho_names <-names(idaho)
names_splited <- strsplit(idaho_names,"wgtp")
names_splited[123]


fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl, destfile = "./data_cleaning/gdp1.csv")
gdp <-read.csv("./data_cleaning/gdp1.csv", skip = 4)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl, destfile = "./data_cleaning/edu.csv", mode = 'wb')
edu <-read.csv("./data_cleaning/edu.csv")
gdp <- select(gdp,1,2,4,5)
colnames(gdp) <- c("CountryCode","rank","CountryName", "MDollars")
unique(gdp$CountryCode)
gdp1 <- filter(gdp, CountryCode != "" &  !is.na(CountryCode) & rank != "" & !is.na(rank) & MDollars != ".." & MDollars != "" & !is.na(MDollars))
gdp1 <- mutate(gdp1, rank = as.integer(rank),MDollars = as.numeric(gsub(",","",MDollars)))

mean(gdp1$MDollars)
res <- grep("^United", gdp1$CountryName, value = TRUE)

merged_gdp <- merge(gdp1,edu, by = c("CountryCode"), all = TRUE)
merged_gdp <- filter(merged_gdp, !is.na(rank))
str(merged_gdp)
lapply(merged_gdp, function(x)length(grep("Fiscal year end: June",x,  value = TRUE)))

install.packages("quantmod")
library(quantmod)
library(lubridate)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
class(sampleTimes)
length(sampleTimes)
years <- year(sampleTimes)
res <- length(years[years == 2012])
res1 <- ymd(grep("^2012",as.character(sampleTimes), value = TRUE ))
res1 <- wday(res1)
length(res1[res1 == 2])
