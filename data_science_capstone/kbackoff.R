# This function receives a sentence and returns
# the 6 most likely next words, considering a Kneser-Ney Backoff calculation.
# To use it is necessary to load the N-Gram table files, previously created.
# Example:

# load("./files/quad_all_newA1.Rda")
# load("./files/tri_all_newA1.Rda")
# load("./files/bi_all_newA1.Rda")
# load("./files/uni_all_newA1.Rda")
###############################################################################


nextWord_kneser <- function(x){
    p <- 0
    n <- 0
    d <- 0.75
    x1 <- unlist(strsplit(x, "[?|\\.|!]+"))
    x1 <- x1[length(x1)]
    x1 <- gsub("[a-z]+@[a-z]+\\.", "",x1)
    x1 <- gsub("www\\.[a-z]+\\.[a-z]+", "",x1)
    x1 <- gsub("[^[:print:]]", "###",x1)
    x1 <- gsub("[Ii]t's ", "it is ",x1)
    x1 <- gsub("'s ", " ",x1)
    x1 <- gsub("'ve ", " have ",x1)
    x1 <- gsub("'u ", " you ",x1)
    x1 <- gsub("'r ", " are ",x1)
    x1 <- gsub("n't", " not",x1)
    x1 <- gsub("'ll ", " will ",x1)
    x1 <- gsub("'d ", " would ",x1)
    x1 <- gsub("[Nn]'t", " not",x1)
    x1 <- gsub("'m ", " am ",x1)
    x1 <- gsub(" 'n ", " ",x1)
    x1 <- gsub("^i | i ", " I ",x1)
    x1 <- gsub(" r ", " are ",x1)
    wor <- removePunctuation(x1)
    wor <- removeNumbers(wor)
    
    wor <-tolower(trimws(paste("<s>", wor, " ")))
    wor1 <- unlist(strsplit(wor, " "))
    print(wor1)
    siz <- length(wor1)
    if(siz > 2){
        print("4gram")
        aux0 <- wor1[as.numeric(length(wor1)-2)]
        aux1 <- wor1[as.numeric(length(wor1)-1)]
        aux2 <- wor1[as.numeric(length(wor1))]
        aux <- as.character(trimws(paste(aux0, aux1, aux2)))
        tri1 <- tri_all[tri_all$word == aux,]
        quad <- quad_all[quad_all$first == aux0 & quad_all$sec == aux1 & quad_all$tri == aux2,]
        quad <- head(quad)
        
        if (nrow(quad) >0){
            
            aux <- as.character(trimws(paste(aux1, aux2)))
            bi1 <- bi_all[bi_all$word == aux, ]
            tri <- tri_all[tri_all$first == aux1 & tri_all$sec == aux2,]
            tri <- tri[tri$tri %in% quad$quad,]
            aux <- as.character(trimws(paste(aux2)))
            uni1 <- uni_all[uni_all$word == aux, ]
            bi <- bi_all[bi_all$first == aux2,]
            bi <- bi[bi$sec %in% quad$quad,]
            
            quad$prob <- (quad[, "freq"]-d)/tri1$freq
            quad$fin <- paste(quad$sec, quad$tri, quad$quad)
            quad$ini <- paste(quad$first, quad$sec, quad$tri)
            
            quad$cont <- sapply(quad$fin, function(x){nrow(quad_all[grep(paste0(x,"$"),quad_all$word),])})
            quad$cont <- (quad$cont-d)/ nrow(tri_all[tri_all$sec == aux1 & tri_all$tri == aux2,])
            quad$lam <- d/tri1$freq*sapply(quad$ini, function(x){nrow(quad_all[grep(paste0("^",x),quad_all$word),])})
            
            tri$cont <- sapply(paste(tri$sec, tri$tri), function(x){nrow(tri_all[grep(paste0(x,"$"),tri_all$word),])})
            tri$cont <- tri$cont/ nrow(bi_all[bi_all$sec == aux2,])
            tri$lam <- d/bi1$freq*sapply(paste(aux1, aux2), function(x){nrow(tri_all[grep(paste0("^",x),tri_all$word),])})
            
            bi$cont <- sapply(paste(bi$sec), function(x){nrow(bi_all[grep(paste0(x,"$"),bi_all$word),])})
            bi$cont <- bi$cont/ nrow(uni_all)
            bi$lam <- d/uni1$freq*sapply(aux2, function(x){nrow(bi_all[grep(paste0("^",x),bi_all$word),])})
            
            
            quad$tot <- quad[, "prob"] + quad$lam*quad$cont + tri$lam*tri$cont + bi$lam * bi$cont
            
            res <- quad[, c("quad", "tot")]
            res <- head(res[order(res$tot, decreasing = TRUE),],50)
        }else{
            print("backoff 3gram")
            aux <- as.character(trimws(paste(aux1, aux2)))
            bi1 <- bi_all[bi_all$word == aux, ]
            tri <- tri_all[tri_all$first == aux1 & tri_all$sec == aux2,]
            tri <- head(tri)
            if(nrow(tri) > 0){
                
                aux <- as.character(trimws(paste(aux2)))
                uni1 <- uni_all[uni_all$word == aux, ]
                bi <- bi_all[bi_all$first == aux2,]
                bi <- bi[bi$sec %in% tri$tri,]
                
                tri$prob <- (tri[, "freq"]-d)/bi1$freq
                tri$fin <- paste(tri$sec, tri$tri)
                tri$ini <- paste(tri$first, tri$sec)
                
                tri$cont <- sapply(tri$fin, function(x){nrow(tri_all[grep(paste0(x,"$"),tri_all$word),])})
                tri$cont <- (tri$cont-d)/ nrow(bi_all[bi_all$sec == aux2,])
                tri$lam <- d/bi1$freq*sapply(tri$ini, function(x){nrow(tri_all[grep(paste0("^",x),tri_all$word),])})
                
                
                bi$cont <- sapply(paste(bi$sec), function(x){nrow(bi_all[grep(paste0(x,"$"),bi_all$word),])})
                print(bi)
                bi$cont <- (bi$cont-d)/ nrow(uni_all)
                bi$lam <- d/uni1$freq*sapply(aux2, function(x){nrow(bi_all[grep(paste0("^",x),bi_all$word),])})
                
                tri$tot <- tri[, "prob"] + tri$lam*tri$cont + bi$lam * bi$cont
                
                
                res <- tri[, c("tri", "tot")]
                res <- head(res[order(res$tot, decreasing = TRUE),],50)
                
                
            }else{
                print("backoff 2gram")
                
                aux <- as.character(trimws(paste(aux2)))
                uni1 <- uni_all[uni_all$word == aux, ]
                bi <- bi_all[bi_all$first == aux2,]
                bi <- head(bi)
                if(nrow(bi)> 0){
                    
                    bi$prob <- (bi[, "freq"]-d)/uni1$freq
                    bi$fin <- bi$sec
                    bi$ini <- bi$first
                    
                    bi$cont <- sapply(bi$fin, function(x){nrow(bi_all[grep(paste0(x,"$"),bi_all$word),])})
                    bi$cont <- (bi$cont-d)/ nrow(uni_all)
                    bi$lam <- d/uni1$freq*sapply(bi$ini, function(x){nrow(bi_all[grep(paste0("^",x),bi_all$word),])})
                    
                    bi$tot <- bi[, "prob"] + bi$lam * bi$cont
                    
                    res <- bi[, c("sec", "tot")]
                    res <- head(res[order(res$tot, decreasing = TRUE),],50)
                    
                    
                }else{
                    p <- "Not found"
                    n <- 0
                    res <- data.frame(word = n, prob = p)
                    res <- head(res[order(res$prob, decreasing = TRUE),],1)
                }
            }
        }
        
        
    }else if (siz > 1){
        print("3gram")
        aux1 <- wor1[as.numeric(length(wor1)-1)]
        aux2 <- wor1[as.numeric(length(wor1))]
        
        aux <- as.character(trimws(paste(aux1, aux2)))
        bi1 <- bi_all[bi_all$word == aux, ]
        tri <- tri_all[tri_all$first == aux1 & tri_all$sec == aux2,]
        tri <- head(tri)
        if(nrow(tri) > 0){
            aux <- as.character(trimws(paste(aux2)))
            uni1 <- uni_all[uni_all$word == aux, ]
            bi <- bi_all[bi_all$first == aux2,]
            bi <- bi[bi$sec %in% tri$tri,]
            
            tri$prob <- (tri[, "freq"]-d)/bi1$freq
            tri$fin <- paste(tri$sec, tri$tri)
            tri$ini <- paste(tri$first, tri$sec)
            
            tri$cont <- sapply(tri$fin, function(x){nrow(tri_all[grep(paste0(x,"$"),tri_all$word),])})
            tri$cont <- (tri$cont-d)/ nrow(bi_all[bi_all$sec == aux2,])
            tri$lam <- d/bi1$freq*sapply(tri$ini, function(x){nrow(tri_all[grep(paste0("^",x),tri_all$word),])})
            
            
            bi$cont <- sapply(paste(bi$sec), function(x){nrow(bi_all[grep(paste0(x,"$"),bi_all$word),])})
            bi$cont <- (bi$cont-d)/ nrow(uni_all)
            bi$lam <- d/uni1$freq*sapply(aux2, function(x){nrow(bi_all[grep(paste0("^",x),bi_all$word),])})
            
            tri$tot <- tri[, "prob"] + tri$lam*tri$cont + bi$lam * bi$cont
            
            res <- tri[, c("tri", "tot")]
            res <- head(res[order(res$tot, decreasing = TRUE),],50)
        }else{
            print("backoff 2gram")
            aux2 <- wor1[as.numeric(length(wor1))]
            
            aux <- as.character(trimws(paste(aux2)))
            uni1 <- uni_all[uni_all$word == aux, ]
            bi <- bi_all[bi_all$first == aux2,]
            bi <- head(bi)
            if(nrow(bi)> 0){
                bi$prob <- (bi[, "freq"]-d)/uni1$freq
                bi$fin <- bi$sec
                bi$ini <- bi$first
                
                bi$cont <- sapply(bi$fin, function(x){nrow(bi_all[grep(paste0(x,"$"),bi_all$word),])})
                bi$cont <- (bi$cont-d)/ nrow(uni_all)
                bi$lam <- d/uni1$freq*sapply(bi$ini, function(x){nrow(bi_all[grep(paste0("^",x),bi_all$word),])})
                
                bi$tot <- bi[, "prob"] + bi$lam * bi$cont
                
                res <- bi[, c("sec", "tot")]
                res <- head(res[order(res$tot, decreasing = TRUE),],50)
                
            }else{
                p <- "Not found"
                n <- 0
                res <- data.frame(word = n, prob = p)
                res <- head(res[order(res$prob, decreasing = TRUE),],1)
            }
        }
        
    }else {
        print("2gram")
        aux2 <- wor1[as.numeric(length(wor1))]
        
        aux <- as.character(trimws(paste(aux2)))
        uni1 <- uni_all[uni_all$word == aux, ]
        bi <- bi_all[bi_all$first == aux2,]
        bi <- head(bi)
        if(nrow(bi)> 0){
            bi$prob <- (bi[, "freq"]-d)/uni1$freq
            bi$fin <- bi$sec
            bi$ini <- bi$first
            
            bi$cont <- sapply(bi$fin, function(x){nrow(bi_all[grep(paste0(x,"$"),bi_all$word),])})
            bi$cont <- (bi$cont-d)/ nrow(uni_all)
            bi$lam <- d/uni1$freq*sapply(bi$ini, function(x){nrow(bi_all[grep(paste0("^",x),bi_all$word),])})
            
            bi$tot <- bi[, "prob"] + bi$lam * bi$cont
            
            res <- bi[, c("sec", "tot")]
            res <- head(res[order(res$tot, decreasing = TRUE),],50)
            
        }else{
            p <- "Not found"
            n <- 0
            res <- data.frame(word = n, prob = p)
            res <- head(res[order(res$prob, decreasing = TRUE),],1)
        }
        
    }
    names(res) <- c("word", "prob")
    res
    
    
}

save(nextWord_kneser, file = "C:/Users/tiago_000/Documents/GitHub/Coursera_DS_Capstone/project_app/nextWord_kneser.Rda")

