
# Load the necessary libraries
library(plyr)
library(tm)
library(RWeka)
library(NLP)
library(openNLP)
library(magrittr)
library(openNLPmodels.en);
library(SnowballC)
library(slam)


start <- "sstrtss"

# Bad words list
#################################
url <- 'https://gist.githubusercontent.com/ryanlewis/a37739d710ccdb4b406d/raw/0fbd315eb2900bb736609ea894b9bde8217b991a/google_twunter_lol'
badwords <-read.csv(url, header = FALSE)



# Clean corpus
# This function removes pontuation, numbers, badwords,
# it also introduces a start mark on each sentence
#############################################################
clean_sent <- function(j, name){
    print("00")
    j <- gsub("[Ii]t's ", "it is ",j)
    j <- gsub("'s ", " ",j)
    j <- gsub("'ve ", " have ",j)
    j <- gsub("'u ", " you ",j)
    j <- gsub("'r ", " are ",j)
    j <- gsub("n't", " not",j)
    print("01")
    j <- gsub("'d ", " would ",j)
    j <- gsub("'ll ", " will ",j)
    j <- gsub("[Nn]'t", " not",j)
    j <- gsub("'m ", " am ",j)
    j <- gsub(" 'n ", " ",j)
    j <- gsub("^i | i ", " I ",j)
    j <- gsub(" r ", " are ",j)
    print("1")
    corp <- Corpus(VectorSource(j))
    print("2")
    corp <- tm_map(corp, PlainTextDocument) 
    print("3")
    corp <- tm_map(corp, removePunctuation)
    print("4")
    corp <- tm_map(corp, removeNumbers)
    print("5")
    corp <- tm_map(corp, content_transformer(tolower))
    print("6")
    corp <- tm_map(corp, removeWords, badwords$V1)
    print("7")
    #corp <- tm_map(corp, removeWords, stopwords("english"))
    print("8")
    corp <- tm_map(corp, content_transformer( function(x) gsub(paste0("^", start), "<s>", x)))
    print("9")
    corp <- tm_map(corp, stripWhitespace)
    print("10")
    #corp_copy <- corp
    #corp <- tm_map(corp, stemDocument, language = "english")
    corp

}


load("./files/train1.Rda")
w <- train[1:1000000]
# Remove sentences with less than three words
w <- w[sapply(gregexpr("\\W+", w), length) + 1 > 2]
res <- clean_sent(w)
save(res, file = "./files/res_new_1.Rda")

load("./files/res_new_1.Rda")
# Create 3-Grams
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
dtm <- DocumentTermMatrix(res, control = list(tokenize = TrigramTokenizer,
                                              wordLengths=c(6, Inf), 
                                              bounds=list(global=c(2, Inf))))
print("11")
#dtm1 <- removeSparseTerms(dtm, 0.999)
print("12")

freq1 <- colapply_simple_triplet_matrix(dtm,sum)
print("13")
freq <- sort(freq1, decreasing = TRUE)
print("14")
words <- as.character(names(freq))
tri_freq <- data.frame(name = words, count = freq)
tri_tot <- tri_freq

# Save de the frequency table
write.table(tri_tot,file=paste0("./freq/tri_freq_","train",".txt"))

rm(tri_tot)
rm(tri_freq)
gc()

# Create 2-Grams
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
dtm <- DocumentTermMatrix(res, control = list(tokenize = BigramTokenizer,
                                              wordLengths=c(3, Inf), 
                                              bounds=list(global=c(2, Inf))))
print("11")
#dtm1 <- removeSparseTerms(dtm, 0.999)
print("12")

freq1 <- colapply_simple_triplet_matrix(dtm,sum)
print("13")
freq <- sort(freq1, decreasing = TRUE)
print("14")
words <- as.character(names(freq))
bi_freq <- data.frame(name = words, count = freq)
bi_tot <- bi_freq

# Save the frequency table
write.table(bi_tot,file=paste0("./freq/bi_freq_","train",".txt"))

rm(bi_tot)
rm(bi_freq)
gc()

# Create 1-Grams
UnigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
dtm <- DocumentTermMatrix(res, control = list(tokenize = UnigramTokenizer, wordLengths=c(1,Inf),
                                              bounds=list(global=c(2, Inf))))
print("11")
#dtm1 <- removeSparseTerms(dtm, 0.999)
print("12")

freq1 <- colapply_simple_triplet_matrix(dtm,sum)
print("13")
freq <- sort(freq1, decreasing = TRUE)
print("14")
words <- as.character(names(freq))
uni_freq <- data.frame(name = words, count = freq)
uni_tot <- uni_freq

# Save the frequency table
write.table(uni_tot,file=paste0("./freq/uni_freq_","train",".txt"))

rm(uni_tot)
rm(uni_freq)
gc()


# Create 4-Grams
QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
dtm <- DocumentTermMatrix(res, control = list(tokenize = QuadgramTokenizer, 
                                              wordLengths=c(8, Inf), 
                                              bounds=list(global=c(2, Inf))))
print("11")
#dtm1 <- removeSparseTerms(dtm, 0.999)
print("12")

freq1 <- colapply_simple_triplet_matrix(dtm,sum)
print("13")
freq <- sort(freq1, decreasing = TRUE)
print("14")
words <- as.character(names(freq))
quad_freq <- data.frame(name = words, count = freq)
quad_tot <- quad_freq

# Save de the frequency table
write.table(quad_tot,file=paste0("./freq/quad_freq_","train",".txt"))



rm(quad_tot)
rm(quad_freq)
gc()




#load("./files/tri_all.Rda")
quad_all <- read.table(file="./freq/quad_freq_train.txt")
nrow(quad_all)
colnames(quad_all) <- c("word", "freq")
#quad_all$freq <- sapply(quad_all$freq, function(x){y <- x - 1})
#quad_all <- quad_all[quad_all$freq > 0,]
quad_all$first <- sapply(strsplit(as.character(quad_all$word), " "), "[", 1)
quad_all$sec <-  sapply(strsplit(as.character(quad_all$word), " "), "[", 2)  
quad_all$tri <-  sapply(strsplit(as.character(quad_all$word), " "), "[", 3)  
quad_all$quad <-  sapply(strsplit(as.character(quad_all$word), " "), "[", 4) 
quad_all$discount <- 1



quad_ind <- vector(length = 5)
k <- 5
for(i in 1:5){
    
    quad_ind[i] <- ((i+1)*length(quad_all$freq[quad_all$freq == (i+1)])/(length(quad_all$freq[quad_all$freq == i]))
                   -(i*(k+1)*length(quad_all$freq[quad_all$freq == (k+1)])/(length(quad_all$freq[quad_all$freq == 1]))))/
        (1-((k+1)*length(quad_all$freq[quad_all$freq == (k+1)])/(length(quad_all$freq[quad_all$freq == 1]))))/i
}

for(i in 1:5){
    quad_all[quad_all$freq == i , "discount"] <- quad_ind[i]
}

quad_all <- quad_all[order(-quad_all$freq),]



tri_all <- read.table(file="./freq/tri_freq_train.txt")
colnames(tri_all) <- c("word", "freq")
#tri_all$freq <- sapply(tri_all$freq, function(x){y <- x - 1})
#tri_all <- tri_all[tri_all$freq > 0,]
tri_all$first <- sapply(strsplit(as.character(tri_all$word), " "), "[", 1)
tri_all$sec <-  sapply(strsplit(as.character(tri_all$word), " "), "[", 2)  
tri_all$tri <-  sapply(strsplit(as.character(tri_all$word), " "), "[", 3)  
tri_all$discount <- 1

bi_all <- read.table(file="./freq/bi_freq_train.txt")
colnames(bi_all) <- c("word", "freq")
#bi_all$freq <- sapply(bi_all$freq, function(x){y <- x - 1})
#bi_all <- bi_all[bi_all$freq > 0,]
nrow(bi_all)
length(bi_all[bi_all$freq == 1, "freq"])
bi_all$first <- sapply(strsplit(as.character(bi_all$word), " "), "[", 1)
bi_all$sec <-  sapply(strsplit(as.character(bi_all$word), " "), "[", 2)  
bi_all$discount <- 1

uni_all <- read.table(file="./freq/uni_freq_train.txt")
colnames(uni_all) <- c("word", "freq")



bi_ind <- vector(length = 5)
tri_ind <- vector(length = 5)
k <- 5
for(i in 1:5){
    # bi_ind[i] <- (i+1)*length(bi_freq[bi_freq == (i+1)])/(length(bi_freq[bi_freq == i]))
    bi_ind[i] <- ((i+1)*length(bi_all$freq[bi_all$freq == (i+1)])/(length(bi_all$freq[bi_all$freq == i]))
                  -(i*(k+1)*length(bi_all$freq[bi_all$freq == (k+1)])/(length(bi_all$freq[bi_all$freq == 1]))))/
        (1-((k+1)*length(bi_all$freq[bi_all$freq == (k+1)])/(length(bi_all$freq[bi_all$freq == 1]))))/i
    
    #tri_ind[i] <- (i+1)*length(tri_freq[tri_freq == (i+1)])/(length(tri_freq[tri_freq == i]))
    tri_ind[i] <- ((i+1)*length(tri_all$freq[tri_all$freq == (i+1)])/(length(tri_all$freq[tri_all$freq == i]))
                   -(i*(k+1)*length(tri_all$freq[tri_all$freq == (k+1)])/(length(tri_all$freq[tri_all$freq == 1]))))/
        (1-((k+1)*length(tri_all$freq[tri_all$freq == (k+1)])/(length(tri_all$freq[tri_all$freq == 1]))))/i
}

for(i in 1:5){
    bi_all[bi_all$freq == i , "discount"] <- bi_ind[i]
    tri_all[tri_all$freq == i , "discount"] <- tri_ind[i]
}

tri_all <- tri_all[order(-tri_all$freq),] 
bi_all <- bi_all[order(-bi_all$freq),] 
uni_all <- uni_all[order(-uni_all$freq),] 

save(tri_all, file = "./files/tri_all_newA1.Rda")
save(bi_all, file = "./files/bi_all_newA1.Rda")
save(uni_all, file = "./files/uni_all_newA1.Rda")
save(quad_all, file = "./files/quad_all_newA1.Rda")


