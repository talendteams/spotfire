###################################################
### chunk number 1: setup
###################################################
rm(list = ls())
if (!file.exists("tables")) dir.create("tables")
set.seed(290875)
options(prompt = "R> ", continue = "+  ",
    width = 63, # digits = 4, 
    SweaveHooks = list(leftpar = function() 
        par(mai = par("mai") * c(1, 1.05, 1, 1))))
HSAURpkg <- require("HSAUR")
if (!HSAURpkg) stop("cannot load package ", sQuote("HSAUR"))
rm(HSAURpkg)
a <- Sys.setlocale("LC_ALL", "C")
book <- TRUE
refs <- cbind(c("AItR", "SI", "CI", "ANOVA", "MLR", "GLM", 
                "DE", "RP", "SA", "ALDI", "ALDII", "MA", "PCA", 
                "MDS", "CA"), 1:15)
ch <- function(x, book = TRUE) {
    ch <- refs[which(refs[,1] == x),]
    if (book) {
        return(paste("Chapter~\\\\ref{", ch[1], "}", sep = ""))
    } else {
        return(paste("Chapter~\\\\ref{", ch[2], "}", sep = ""))
    }
}


###################################################
### chunk number 2: MDS-setup
###################################################
x <- library("ape")


###################################################
### chunk number 3: MDS-voles-cmdscale
###################################################
data("watervoles", package = "HSAUR")
voles_mds <- cmdscale(watervoles, k = 13, eig = TRUE)
voles_mds$eig


###################################################
### chunk number 4: MDS-voles-criterion1
###################################################
sum(abs(voles_mds$eig[1:2]))/sum(abs(voles_mds$eig)) 


###################################################
### chunk number 5: MDS-voles-criterion2
###################################################
sum((voles_mds$eig[1:2])^2)/sum((voles_mds$eig)^2)


###################################################
### chunk number 6: MDS-watervoles-plot
###################################################
x <- voles_mds$points[,1]
y <- voles_mds$points[,2]
plot(x, y, xlab = "Coordinate 1", ylab = "Coordinate 2",
     xlim = range(x)*1.2, type = "n")
text(x, y, labels = colnames(watervoles))


###################################################
### chunk number 7: MDS-watervoles-mst
###################################################
library("ape")
st <- mst(watervoles)
plot(x, y, xlab = "Coordinate 1", ylab = "Coordinate 2",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(watervoles)) {
    w1 <- which(st[i, ] == 1)
    segments(x[i], y[i], x[w1], y[w1])
}
text(x, y, labels = colnames(watervoles))


###################################################
### chunk number 8: MDS-voting
###################################################
library("MASS")
data("voting", package = "HSAUR")
voting_mds <- isoMDS(voting)


###################################################
### chunk number 9: MDS-voting-plot
###################################################
x <- voting_mds$points[,1]
y <- voting_mds$points[,2]
plot(x, y, xlab = "Coordinate 1", ylab = "Coordinate 2",
     xlim = range(voting_mds$points[,1])*1.2, type = "n")
text(x, y, labels = colnames(voting))
voting_sh <- Shepard(voting[lower.tri(voting)], 
                     voting_mds$points)


###################################################
### chunk number 10: MDS-voting-Shepard
###################################################
plot(voting_sh, pch = ".", xlab = "Dissimilarity", 
     ylab = "Distance", xlim = range(voting_sh$x), 
     ylim = range(voting_sh$x))
lines(voting_sh$x, voting_sh$yf, type = "S")


