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
### chunk number 2: thissetup
###################################################
library("mclust")
library("mvtnorm")
mai <- par("mai")
options(SweaveHooks = list(rmai = function() { par(mai = mai * c(1,1,1,2))}))


###################################################
### chunk number 3: CA-planets-scatter
###################################################
data("planets", package = "HSAUR")
library("scatterplot3d")
scatterplot3d(log(planets$mass), log(planets$period), 
    log(planets$eccen), type = "h", angle = 55, 
    pch = 16, y.ticklabs = seq(0, 10, by = 2), 
    y.margin.add = 0.1, scale.y = 0.7)


###################################################
### chunk number 4: CA-planet-ss
###################################################
rge <- apply(planets, 2, max) - apply(planets, 2, min)
planet.dat <- sweep(planets, 2, rge, FUN = "/")
n <- nrow(planet.dat)
wss <- rep(0, 10)
wss[1] <- (n - 1) * sum(apply(planet.dat, 2, var))
for (i in 2:10)
    wss[i] <- sum(kmeans(planet.dat, 
                         centers = i)$withinss)
plot(1:10, wss, type = "b", xlab = "Number of groups",
     ylab = "Within groups sum of squares")


###################################################
### chunk number 5: CA-planets-kmeans3
###################################################
planet_kmeans3 <- kmeans(planet.dat, centers = 3)
table(planet_kmeans3$cluster)


###################################################
### chunk number 6: CA-planets-ccent
###################################################
ccent <- function(cl) {
    f <- function(i) colMeans(planets[cl == i,])
    x <- sapply(sort(unique(cl)), f)
    colnames(x) <- sort(unique(cl))
    return(x)
}


###################################################
### chunk number 7: CA-planets--kmeans3-ccent
###################################################
ccent(planet_kmeans3$cluster)


###################################################
### chunk number 8: CA-planets-kmeans5
###################################################
planet_kmeans5 <- kmeans(planet.dat, centers = 5)
table(planet_kmeans5$cluster)
ccent(planet_kmeans5$cluster)


###################################################
### chunk number 9: CA-planets-mclust
###################################################
library("mclust")
planet_mclust <- Mclust(planet.dat)


###################################################
### chunk number 10: CA-planets-mclust-plot
###################################################
plot(planet_mclust, planet.dat, what = "BIC", col = "black", 
     ylab = "-BIC", ylim = c(0, 350))  


###################################################
### chunk number 11: CA-planets-mclust-print
###################################################
print(planet_mclust)


###################################################
### chunk number 12: CA-planets-mclust-scatter
###################################################
clPairs(planet.dat, 
    classification = planet_mclust$classification, 
    symbols = 1:3, col = "black")


###################################################
### chunk number 13: CA-planets-mclust-scatterclust
###################################################
scatterplot3d(log(planets$mass), log(planets$period), 
    log(planets$eccen), type = "h", angle = 55, 
    scale.y = 0.7, pch = planet_mclust$classification, 
    y.ticklabs = seq(0, 10, by = 2), y.margin.add = 0.1)


###################################################
### chunk number 14: CA-planets-mclust-mu
###################################################
table(planet_mclust$classification)
ccent(planet_mclust$classification)


