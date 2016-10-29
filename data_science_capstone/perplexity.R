load("./files/quad_all_test1.Rda")
load("./files/tri_all_test1.Rda")
load("./files/bi_all_test1.Rda")
load("./files/uni_all_test1.Rda")

quad_test <- quad_all
tri_test <- tri_all
bi_test <- bi_all
uni_test <- uni_all

load("./files/quad_all_product.Rda")
load("./files/tri_all_product.Rda")
load("./files/bi_all_product.Rda")
load("./files/uni_all_product.Rda")


# Probability function for 2-Grams
f2 <-function(x){ 
    x1 <- unlist(strsplit(as.character(x), " "))
    x2 <- bi_all[bi_all$word == as.character(x), "freq"]/uni_all[grep(paste0("^",paste(x1[1]),"$"),uni_all$word), "freq"]
}

# Probability function for 3-Grams
f3 <-function(x){ 
    x1 <- unlist(strsplit(as.character(x), " "))
    x2 <- tri_all[tri_all$word == as.character(x), "freq"]/bi_all[grep(paste0("^",paste(x1[1], x1[2]),"$"),bi_all$word), "freq"]
}

# Probability function for 4-Grams
f4 <-function(x){ 
    x1 <- unlist(strsplit(as.character(x), " "))
    x2 <- quad_all[quad_all$word == as.character(x), "freq"]/tri_all[grep(paste0("^",paste(x1[1], x1[2], x1[3]),"$"),tri_all$word), "freq"]
}

# Probability function for 5-Grams
f5 <-function(x){ 
    x1 <- unlist(strsplit(as.character(x), " "))
    num <- quad_all[quad_all$word == as.character(x), "freq"]
    if(length(num) > 0){
        den <- tri_all[grep(paste0("^",paste(x1[1], x1[2], x1[3]),"$"),tri_all$word), "freq"]
        x2 <- num/den
    }else{
        num <- tri_all[grep(paste0("^",paste(x1[2], x1[3], x1[4]),"$"), tri_all$word) , "freq"]
        if(length(num) > 0){
            den <- bi_all[grep(paste0("^",paste(x1[2], x1[3]),"$"),bi_all$word), "freq"]
            x2 <- num/den
        }else{
            num <- bi_all[grep(paste0("^",paste(x1[3], x1[4]),"$"),bi_all$word), "freq"]
            if(length(num) > 0){
                den <- uni_all[grep(paste0("^",paste(x1[3]),"$"),uni_all$word), "freq"]
                x2 <- num/den
            }else{
                x2 <- base_prob1
            }
        }
    }
    
}

# Zero probability imputation
base_prob4 <- nrow(tri_all[tri_all$freq == 4,])/(nrow(uni_all)^4-nrow(quad_all))
base_prob3 <- nrow(tri_all[tri_all$freq == 4,])/(nrow(uni_all)^3-nrow(tri_all))
base_prob2 <- nrow(bi_all[bi_all$freq == 4,])/(nrow(uni_all)^2-nrow(bi_all))
base_prob1 <- nrow(uni_all[uni_all$freq == 1])/sum(uni_all$freq)

# Perplexity calculation for 2-Grams
perpl <- vector()
res <- sapply(bi_test$word, f2)
res2 <- res
length(res2[sapply(res2, length)])
res3 <- res2
res3[sapply(res3, length) == 0] <- NA
res3 <- unlist(res3)
res3[is.na(res3)] <- base_prob2
aux <- exp(-sum(log(res3*bi_test$freq))/sum(bi_test$freq))
perpl[1] <- aux

# Perplexity calculation for 3-Grams
res <- sapply(tri_test$word, f3)
res2 <- res
length(res2)
res3 <- res2
length(res3[sapply(res3, length) == 0])
res3[sapply(res3, length) == 0] <- NA
res3 <- unlist(res3)
res3[is.na(res3)] <- base_prob3
perpl[2] <- exp(-sum(log(res3*tri_test$freq))/sum(tri_test$freq))

# Perplexity calculation for 4-Grams
res <- sapply(quad_test$word, f4)
res2 <- res
length(res2[sapply(res2, length)])
res3 <- res2
res3[sapply(res3, length) == 0] <- NA
res3 <- unlist(res3)
res3[is.na(res3)] <- base_prob4
perpl[3] <- exp(-sum(log(res3*quad_test$freq))/sum(quad_test$freq))

# Perplexity calculation for backoff
res <- sapply(quad_test$word, f5)
res2 <- res
length(res2[sapply(res2, length)])
res3 <- res2
res3[sapply(res3, length) == 0] <- NA
res3 <- unlist(res3)
res3[is.na(res3)] <- base_prob4
perpl[4] <- exp(-sum(log(res3*quad_test$freq))/sum(quad_test$freq))


save(perpl, file = "./files/perplexity.Rda")

