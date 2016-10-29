fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl, destfile = "./data_cleaning/gdp.csv")
gdp <-read.csv("./data_cleaning/gdp.csv", skip = 4)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl, destfile = "./data_cleaning/edu.csv", mode = 'wb')
edu <-read.csv("./data_cleaning/edu.csv")

gdp_tbl <- tbl_df(gdp)
edu_tbl <- tbl_df(edu)
gdp_tbl <- select(gdp_tbl,1,2,4,5)
colnames(gdp_tbl) <- c("CountryCode","rank","CountryName", "MDollars")
unique(gdp_tbl1$CountryCode)
gdp_tbl1 <- filter(gdp_tbl, CountryCode != "" &  !is.na(CountryCode) & rank != "" & !is.na(rank) & MDollars != ".." & MDollars != "" & !is.na(MDollars))
gdp_tbl1 <- mutate(gdp_tbl1, rank = as.integer(rank),MDollars = as.numeric(gsub(",","",MDollars)))
merged_gdp <- merge(gdp_tbl1,edu_tbl, by = c("CountryCode"), all = TRUE)
merged_gdp <- filter(merged_gdp, !is.na(rank))

sum(!is.na(filter(merged_gdp, !is.na(CountryCode))$MDollars))
merged_gdp <- filter(merged_gdp, !is.na(rank) & !is.na(CountryCode))
res <- arrange(merged_gdp, MDollars)
tail(select(res,rank, CountryCode,MDollars ))

res <- filter(merged_gdp , !is.na(Income.Group))
res1 <-  group_by(res,Income.Group) 


summarize(res1, mean(rank, na.rm = TRUE))

res1 <-  group_by(merged_gdp,CountryCode, Income.Group) 
summarize(res1, quantile(res1$rank,  type = 5 ))
merged_gdp1 <- mutate(merged_gdp, quant= quantile(merged_gdp$rank,  type = 5 ,na.rm = TRUE))
filter(merged_gdp1, merged_gdp1$ )

