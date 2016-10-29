getwd()
setwd("C:/Users/tiago_000/Documents//GitHub/R_progamming")
if(!file.exists("data_cleaning")){
    dir.create("data_cleaning")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data_cleaning/dataDownloaded.csv")
data <-read.csv("./data_cleaning/dataDownloaded.csv")
tbldata <- tbl_df(data)
str(tbldata)
agricultureLogical <- tbldata$ACR == 3 & tbldata$AGS == 6 & !is.na(tbldata$ACR) & !is.na(tbldata$AGS == 6)
which(agricultureLogical)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileUrl, destfile = "./data_cleaning/pic.jpg", mode = 'wb')
pic <- readJPEG("./data_cleaning/pic.jpg", native = TRUE)
quantile(pic, probs = c(0.3, 0.8))

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl, destfile = "./data_cleaning/gdp.csv")
gdp <-read.csv("./data_cleaning/gdp.csv", skip = 4)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl, destfile = "./data_cleaning/edu.csv")
edu <-read.csv("./data_cleaning/edu.csv")
str(gdp)
head(gdp)
tail(gdp)
str(edu)
head(edu)
gdp_tbl <- tbl_df(gdp)
gdp_tbl <- select(gdp_tbl,1,2,4,5)
colnames(gdp_tbl) <- c("CountryCode","rank","CountryName", "MDollars")

gdp_tbl1 <- filter(gdp_tbl, length(CountryCode)>1 &  !is.na(CountryCode))
head(gdp_tbl)
length(gdp_tbl1$CountryCode)
gdp_tbl1 <- gdp_tbl1[,complete.cases(gdp_tbl1$CountryCode)]
merged_gdp <- merge(gdp_tbl1,edu,by = "CountryCode", all = TRUE)
sum(!is.na(unique(merged_gdp$MDollars)))

