getwd()
setwd("C:/Users/tiago_000/Documents//GitHub/R_progamming")
if(!file.exists("data_cleaning")){
    dir.create("data_cleaning")
}

library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "d5f496e987909d0209e4",
                   secret = "ab491d6d62d025a7cf7860d01e529209c5505b56")

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
json1 <- content(req)
json2 <- jsonlite::fromJSON(jsonlite::toJSON(json1))
str(json2)

head(json2$created_at)
json2[json2$name== "datasharing","created_at"]

install.packages("sqldf") 
library(sqldf)


con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(con)
nchar(htmlCode[c(10,20,30,100)])

x <- read.fwf(
    file=url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"),
    skip=4,
    widths=c(9, 5, 5, 4,5,4, 4,5,4, 4,5,4, 4))
head(x)
x <- x[c(1,3,4, 6, 7, 9,10, 12,13)]
y <- x[c(4)]
sum(y)
