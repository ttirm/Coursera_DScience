getwd()
setwd("C:/Users/tiago_000/Documents//GitHub/R_progamming")
if(!file.exists("data_cleaning")){
    dir.create("data_cleaning")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data_cleaning/data1.csv")
survey <-read.csv("./data_cleaning/data1.csv")
str(survey)
head(survey)
head(survey$VAL)
values <- survey$VAL[complete.cases(survey$VAL)] 
length( values[values>=24])
unique(survey$FES)

install.packages("xlsx", dependencies = TRUE)
install.packages("rJava")
fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl1, destfile = "./data_cleaning/data2.xlsx", mode='wb')
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jdk1.8.0_40')
library(xlsx)
dat <- read.xlsx("./data_cleaning/data2.xlsx", sheetIndex = 1, header = TRUE,colIndex = 7:15, rowIndex = 18:23)
sum(dat$Zip*dat$Ext,na.rm=T)

install.packages("XML")
library(XML)
fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(sub("s", "", fileUrl2), useInternal = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode[1]
val <-xpathSApply(rootNode,"//zipcode",xmlValue)
length(val[val==21231])




fileUrl3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl3, destfile = "./data_cleaning/data3.csv", mode='wb')
install.packages("data.table")
library(data.table)
DT <- fread("./data_cleaning/data3.csv")
DT[DT$pwgtp15 ==]
DT[, Mean:=mean(pwgtp15), by=list(Y, Z)]

