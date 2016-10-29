
# Load the necessary libraries
library(tm)
library(RWeka)
library(wordcloud)
library(NLP)
library(openNLP)
library(magrittr)
library(openNLPmodels.en);
library(SnowballC)
library(textcat)




# Load data
##################################
stat <- data.frame(file = c("Blogs", "News", "Twitter", "All"))
files <- c("./final/en_US/en_US.blogs.txt", "./final/en_US/en_US.news.txt", "./final/en_US/en_US.twitter.txt")

for(j in 1:3){
    siz <-0
    i <- 1
    sent_vec1 <- vector()
    
    print(files[j])
    con <- file(files[j], open = "rb")
    fil <- readLines(con, encoding = "UTF-8", skipNul = TRUE, warn = FALSE)
    fil <- iconv(fil, "UTF8", "ASCII", sub="")
    fil <- gsub("\1", "",fil)
    # Remove non-English sentences
    fil <- fil[textcat(fil, p = textcat::ECIMCI_profiles) == "en"]

    # Remove emails and websites
    fil <- paste(fil, collapse = " ")
    fil <- gsub("[a-z]+@[a-z]+\\.", "",fil)
    fil <- gsub("www\\.[a-z]+\\.[a-z]+", "",fil)
    fil <- gsub("[^[:print:]]", "###",fil)
    
    # Split the text in sentences
    sent_vec <- unlist(strsplit(fil, "[?|\\.|!]+"))
    
    # Remove unnecessary variabnles
    rm(fil)
    gc()
    
    # Introduce a start mark in the beginning of the phrase
    start <- "sstrtss"
    sent_vec <- gsub("^*", paste0(start," "),sent_vec)
    sent_vec1 <- sent_vec

    close(con)
    
    
    
    save(sent_vec1, file = paste0("./files/sent_vec2_", as.character(stat$file[j]), ".Rda"))
    
    rm(sent_vec1)
    gc()
    
}

gc()


# Merge files
##################################
load("./files/sent_vec2_blogs.Rda")
blog <- sent_vec1

load("./files/sent_vec2_news.Rda")
news <- sent_vec1

load("./files/sent_vec2_twitter.Rda")
twitter <- sent_vec1 

all_data <- c(blog, news, twitter)

rm(blog)
rm(news)
rm(twitter)
gc()

# Split the data in train and test set
##################################
sent_vec_rand <-sample(all_data, length(all_data))
off <- length(sent_vec_rand)*0.7
train <- sent_vec_rand[1:off]
save(train, file="./files/train1.Rda")
test <- sent_vec_rand[-(1:off)]
save(test, file="./files/test1.Rda")

