load("./files/uni_all_newA2.Rda")
uni_all2 <- uni_all
load("./files/uni_all_newA1.Rda")
uni_all1 <- uni_all

uni_all <- ddply(rbind(uni_all1, uni_all2), .(word), summarize, freq = sum(freq))
save(uni_all, file = "./files/uni_all_total.Rda")

rm(uni_all2)
rm(uni_all1)
gc()

load("./files/uni_all_total.Rda")
uni_tot <- uni_all
load("./files/uni_all_newA3.Rda")
uni_all3 <- uni_all

uni_all <- ddply(rbind(uni_tot, uni_all3), .(word), summarize, freq = sum(freq))
save(uni_all, file = "./files/uni_all_total.Rda")

rm(uni_tot)
rm(uni_all3)
gc()

load("./files/uni_all_total.Rda")
uni_tot <- uni_all
load("./files/uni_all_newA4.Rda")
uni_all4<- uni_all

uni_all <- ddply(rbind(uni_tot, uni_all4), .(word), summarize, freq = sum(freq))
save(uni_all, file = "./files/uni_all_total.Rda")

rm(uni_tot)
rm(uni_all4)
gc()

load("./files/uni_all_total.Rda")
uni_tot <- uni_all
load("./files/uni_all_newA5.Rda")
uni_all5<- uni_all

uni_all <- ddply(rbind(uni_tot, uni_all5), .(word), summarize, freq = sum(freq))
save(uni_all, file = "./files/uni_all_total.Rda")

rm(uni_tot)
rm(uni_all5)
gc()

load("./files/uni_all_total.Rda")
uni_tot <- uni_all
load("./files/uni_all_newA6.Rda")
uni_all6<- uni_all

uni_all <- ddply(rbind(uni_tot, uni_all6), .(word), summarize, freq = sum(freq))
save(uni_all, file = "./files/uni_all_total.Rda")

rm(uni_all6)
rm(uni_tot)
gc()

load("./files/bi_all_newA2.Rda")
bi_all2 <- bi_all
load("./files/bi_all_newA1.Rda")
bi_all1 <- bi_all


bi_all <- ddply(rbind(bi_all1, bi_all2), .(word, first, sec), summarize, freq = sum(freq))
save(bi_all, file = "./files/bi_all_total.Rda")

rm(bi_all2)
rm(bi_all1)
gc()

load("./files/bi_all_total.Rda")
bi_tot <- bi_all
load("./files/bi_all_newA3.Rda")
bi_all3 <- bi_all[,1:4]


bi_all <- ddply(rbind(bi_tot, bi_all3), .(word, first, sec), summarize, freq = sum(freq))
save(bi_all, file = "./files/bi_all_total.Rda")

rm(bi_tot)
rm(bi_all3)
gc()

load("./files/bi_all_total.Rda")
bi_tot <- bi_all
load("./files/bi_all_newA4.Rda")
bi_all4 <- bi_all[,1:4]


bi_all <- ddply(rbind(bi_tot, bi_all4), .(word, first, sec), summarize, freq = sum(freq))
save(bi_all, file = "./files/bi_all_total.Rda")

rm(bi_tot)
rm(bi_all4)
gc()

load("./files/bi_all_total.Rda")
bi_tot <- bi_all
load("./files/bi_all_newA5.Rda")
bi_all5 <- bi_all[,1:4]


bi_all <- ddply(rbind(bi_tot, bi_all5), .(word, first, sec), summarize, freq = sum(freq))
save(bi_all, file = "./files/bi_all_total.Rda")

rm(bi_tot)
rm(bi_all5)
gc()

load("./files/bi_all_total.Rda")
bi_tot <- bi_all
load("./files/bi_all_newA6.Rda")
bi_all6 <- bi_all[,1:4]


bi_all <- ddply(rbind(bi_tot, bi_all6), .(word, first, sec), summarize, freq = sum(freq))
save(bi_all, file = "./files/bi_all_total.Rda")

rm(bi_all5)
rm(bi_tot)
gc()

load("./files/tri_all_newA2.Rda")
tri_all2 <- tri_all
load("./files/tri_all_newA1.Rda")
tri_all1 <- tri_all

tri_all <- ddply(rbind(tri_all1, tri_all2), .(word, first, sec, tri), summarize, freq = sum(freq))
save(tri_all, file = "./files/tri_all_total.Rda")

rm(tri_all2)
rm(tri_all1)
gc()

load("./files/tri_all_total.Rda")
tri_tot <- tri_all
load("./files/tri_all_newA3.Rda")
tri_all3 <- tri_all[,1:5]

tri_all <- ddply(rbind(tri_tot, tri_all3), .(word, first, sec, tri), summarize, freq = sum(freq))
save(tri_all, file = "./files/tri_all_total.Rda")

rm(tri_all3)
rm(tri_tot)
gc()

load("./files/tri_all_total.Rda")
tri_tot <- tri_all
load("./files/tri_all_newA4.Rda")
tri_all4 <- tri_all[,1:5]

tri_all <- ddply(rbind(tri_tot, tri_all4), .(word, first, sec, tri), summarize, freq = sum(freq))
save(tri_all, file = "./files/tri_all_total.Rda")

rm(tri_all4)
rm(tri_tot)
gc()

load("./files/tri_all_total.Rda")
tri_tot <- tri_all
load("./files/tri_all_newA5.Rda")
tri_all5 <- tri_all[,1:5]

tri_all <- ddply(rbind(tri_tot, tri_all5), .(word, first, sec, tri), summarize, freq = sum(freq))
save(tri_all, file = "./files/tri_all_total.Rda")

rm(tri_all5)
rm(tri_tot)
gc()

load("./files/tri_all_total.Rda")
tri_tot <- tri_all
load("./files/tri_all_newA6.Rda")
tri_all6 <- tri_all[,1:5]

tri_all <- ddply(rbind(tri_tot, tri_all6), .(word, first, sec, tri), summarize, freq = sum(freq))
save(tri_all, file = "./files/tri_all_total.Rda")

rm(tri_all6)
rm(tri_tot)
gc()

load("./files/quad_all_newA2.Rda")
quad_all2 <- quad_all
load("./files/quad_all_newA1.Rda")
quad_all1 <- quad_all

quad_all <- ddply(rbind(quad_all1, quad_all2), .(word, first, sec, tri, quad), summarize, freq = sum(freq))
save(quad_all, file = "./files/quad_all_total.Rda")

rm(quad_all2)
rm(quad_all1)
gc()

load("./files/quad_all_total.Rda")
quad_tot <- quad_all
load("./files/quad_all_newA3.Rda")
quad_all3 <- quad_all[,1:6]

quad_all <- ddply(rbind(quad_tot, quad_all3), .(word, first, sec, tri, quad), summarize, freq = sum(freq))
save(quad_all, file = "./files/quad_all_total.Rda")

rm(quad_all3)
rm(quad_tot)
gc()

load("./files/quad_all_total.Rda")
quad_tot <- quad_all
load("./files/quad_all_newA4.Rda")
quad_all4 <- quad_all[,1:6]

quad_all <- ddply(rbind(quad_tot, quad_all4), .(word, first, sec, tri, quad), summarize, freq = sum(freq))
save(quad_all, file = "./files/quad_all_total.Rda")

rm(quad_all4)
rm(quad_tot)
gc()

load("./files/quad_all_total.Rda")
quad_tot <- quad_all
load("./files/quad_all_newA5.Rda")
quad_all5 <- quad_all[,1:6]

quad_all <- ddply(rbind(quad_tot, quad_all5), .(word, first, sec, tri, quad), summarize, freq = sum(freq))
save(quad_all, file = "./files/quad_all_total.Rda")

rm(quad_all5)
rm(quad_tot)
gc()

load("./files/quad_all_total.Rda")
quad_tot <- quad_all
load("./files/quad_all_newA6.Rda")
quad_all6 <- quad_all[,1:6]

quad_all <- ddply(rbind(quad_tot, quad_all6), .(word, first, sec, tri, quad), summarize, freq = sum(freq))
save(quad_all, file = "./files/quad_all_total.Rda")

rm(quad_all6)
rm(quad_tot)
gc()


load("./files/quad_all_total.Rda")
load("./files/tri_all_total.Rda")
load("./files/bi_all_total.Rda")
load("./files/uni_all_total.Rda")


save(uni_all, file = "./files/uni_all_product.Rda")
bi_all <- bi_all[bi_all$freq > 3, ]
save(bi_all, file = "./files/bi_all_product.Rda")
tri_all <- tri_all[tri_all$freq > 3,]
save(tri_all, file = "./files/tri_all_product.Rda")
quad_all <- quad_all[quad_all$freq > 3,]
save(quad_all, file = "./files/quad_all_product.Rda")

