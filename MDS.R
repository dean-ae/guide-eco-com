#' title: Multidimensional Scaling for SEER
#' author: Dean Erasmus

## Setup ----

rm(list = ls())

setwd("G:/My Drive/R")

library(tidyverse)
library(MASS)
library(smacof)
library(cluster)
library(ggdendro)
library(vegan)

## Data ----

data <- read_csv("protein.csv")
head(data) # data is a matrix with n rows and p variables

plot(data)

## Standardise ----

df <- data %>%
  # move identifier column to row names
  column_to_rownames(var = "Country") %>% 
  # remove unused variables
  #dplyr::select() %>% 
  # scale values if measured differently
  decostand(method = "standardize")

head(df)

## Dissimilarity ----

?decostand

dmat <- daisy(df, metric = "euclidean")
dmat <- vegdist(df, metric = "euclidean")
# methods include euclidean, jaccard, binomial...

dmat # dissimilarity matrix is n x n with a 0 diagonal

## Clusters ----

tree <- hclust(dmat)
ggdendrogram(tree)
glimpse(tree)

# cluster groups
tree.cut <- cutree(tree, k = 3) # cut tree at height
tree.cut %>% sort() # k clusters of objects

## MDS ----

# function to select MDS method

scaling <- function(dmat, method = "classic") {
  
  # classical scaling
  if (method %in% c("classic", "classical", "mds")) {
    df.mds <- cmdscale(dmat)
    print <- "classical scaling"
    
    # metric smacof
  } else if (method %in% c("smacof", "smacof 1", "metric smacof")) {
    df.mds <- smacof::smacofSym(dmat, type = "ratio")$conf
    print <- "metric SMACOF"
    
    # non-metric smacof
  } else if (method %in% c("smacof 2", "nmds", "non-metric smacof")) {
    df.mds <- smacof::smacofSym(dmat, type = "ordinal")$conf
    print <- "non-metric SMACOF"
    
    # sammon non-metric
  } else if (method %in% c("smacof 1", "sammon", "Sammon")) {
    df.mds <- MASS::sammon(dmat)$points
    print <- "Sammon"
    
    # kruskal non-metric
  } else if (method == "kruskal") {
    df.mds <- MASS::isoMDS(dmat)$points
    print <- "Kruskal"
    
  } 
  df.mds <- df.mds %>% as_tibble()
  colnames(df.mds) <- c("D1", "D2")
  
  print(paste0("Method used: ", print))
  
  return(df.mds)
}


df.mds <- scaling(dmat, method = "nmds")
df.mds

## Plot ----

CP051 <- c("#445B70", "#6DAD7D", "#FFCB79", "#FF96BA", "#FF8470") # b,g,y,p,o

# ggplot

df.mds %>% 
  mutate(rowname = rownames(df), 
         #cluster = as.factor(tree.cut),
         cluster = as.factor(data$GrowthForm)) %>% 
  ggplot(aes(x = D1, y = D2, label = rowname, color = cluster, shape = cluster)) +
  geom_text() +
  geom_point(size = 5, alpha = 0.75) +
  scale_color_manual(values = CP051) +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(), 
        legend.position = 'right',
        axis.text.x = element_blank(),
        axis.text.y = element_blank())

# base package

plot(df.mds, type="n", xlab="", ylab="", xaxt="n", yaxt="n", asp = 1)
for (i in 1:nrow(data)) {
  text(x = df.mds[i,1], 
       y = df.mds[i,2], 
       labels = rownames(df)[i],
       col = CP051[tree.cut[i]])
}

