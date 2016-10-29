# This function receives a sentence and returns
# the 50 most likely next words, considering a Stupid Backoff calculation.
# To use it is necessary to load the N-Gram table files, previously created.
# Example:

# load("./files/quad_all_newA1.Rda")
# load("./files/tri_all_newA1.Rda")
# load("./files/bi_all_newA1.Rda")
# load("./files/uni_all_newA1.Rda")
###############################################################################



# Discount factor
d <- 0.4

nextWord_sBackoff <- function(x){
    p <- 0
    n <- 0
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
    #     vec <- strsplit(wor, " ") 
    #     v <- vec[[1]][!vec[[1]] %in% stopwords('english')]
    #     v <- paste(v[v > 2], collapse = " ")
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
        if (nrow(quad) >0){
            
            quad$prob <- (quad[, "freq"])/tri1$freq
            
            
            p <- quad[, "prob"]
            print(head(quad))
            n <- as.character(quad[, "quad"])
            res <- data.frame(word = n, prob = p)
            res <- head(res[order(res$prob, decreasing = TRUE),],50)
        }else{
            print("backoff 3gram")
            aux <- as.character(trimws(paste(aux1, aux2)))
            bi1 <- bi_all[bi_all$word == aux, ]
            tri <- tri_all[tri_all$first == aux1 & tri_all$sec == aux2,]
            if(nrow(tri) > 0){
                tri$prob <- d*max(tri[, "freq"])/bi1$freq
            
                
                p <- tri[, "prob"]
                n <- as.character(tri[, "tri"])
                res <- data.frame(word = n, prob = p)
                res <- head(res[order(res$prob, decreasing = TRUE),],50)
            }else{
                print("2gram")
                
                aux <- as.character(trimws(paste(aux2)))
                uni1 <- uni_all[uni_all$word == aux, ]
                bi <- bi_all[bi_all$first == aux2,]
                if(nrow(bi)> 0){
                    bi$prob <- d*d*bi[, "freq"]/uni1$freq
                    
                    p <- bi[, "prob"]
                    n <- as.character(bi[, "sec"])
                    res <- data.frame(word = n, prob = p)
                    res <- head(res[order(res$prob, decreasing = TRUE),],50)
                    
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
        if(nrow(tri) > 0){
            tri$prob <- max(tri[, "freq"]-0.75)/bi1$freq
            
            p <- tri[, "prob"]
            n <- as.character(tri[, "tri"])
            res <- data.frame(word = n, prob = p)
            res <- head(res[order(res$prob, decreasing = TRUE),],50)
        }else{
            print("2gram")
            aux2 <- wor1[as.numeric(length(wor1))]
            
            aux <- as.character(trimws(paste(aux2)))
            uni1 <- uni_all[uni_all$word == aux, ]
            bi <- bi_all[bi_all$first == aux2,]
            
            if(nrow(bi)> 0){
                bi$prob <- d*bi[, "freq"]/uni1$freq
                
                p <- bi[, "prob"]
                n <- as.character(bi[, "sec"])
                res <- data.frame(word = n, prob = p)
                res <- head(res[order(res$prob, decreasing = TRUE),],50)
                
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
        if(nrow(bi)> 0){
            bi$prob <- bi[, "freq"]/uni1$freq

            p <- bi[, "prob"]
            n <- as.character(bi[, "sec"])
            res <- data.frame(word = n, prob = p)
            res <- head(res[order(res$prob, decreasing = TRUE),],50)
            
        }else{
            p <- "Not found"
            n <- 0
            res <- data.frame(word = n, prob = p)
            res <- head(res[order(res$prob, decreasing = TRUE),],1)
        }
        
    }
    res
    
    
}