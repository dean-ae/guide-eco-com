#' @title: Multidimensional Scaling for Soil Ecology & Entomology Research Lab
#' @author: Dean Erasmus
#' 

# Setup ----

rm(list = ls())

getwd()
setwd()

# packages

library(tidyverse)
library(MASS)
library(smacof)
library(cluster)
library(ggdendro)
library(vegan)

### ## # ## ### ## # ## ### ## # ## ###

# Data ----

data <- read.csv("protein.csv")

head(data) # data is a matrix with n rows and p variables
plot(data) # shows relationships between all variables

## Standardise ----

df <- data |>
  # move identifier column to row names
  column_to_rownames(var = "Country") |>

  # remove unused variables
  dplyr::select(RedMeat:FrVeg) |>

  # scale values if measured differently
  decostand(method = "standardize")

head(df)

### ## # ## ### ## # ## ### ## # ## ###

## Dissimilarity ----

dmat <- daisy(df, metric = "euclidean")
#dmat <- vegdist(df, metric = "euclidean")
# methods include euclidean, jaccard, binomial...

dmat # dissimilarity matrix is n x n with a 0 diagonal

### ## # ## ### ## # ## ### ## # ## ###

# Clusters ----

tree <- hclust(dmat)
ggdendrogram(tree)
glimpse(tree)

# cluster groups
tree.cut <- cutree(tree, k = 3) # cut tree into k clusters
tree.cut |> sort()

### ## # ## ### ## # ## ### ## # ## ###

# MDS ----

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
  df.mds <- df.mds |> as_tibble()
  colnames(df.mds) <- c("D1", "D2")
  
  print(paste0("Method used: ", print))
  
  return(df.mds)
}

df.mds <- scaling(dmat, method = "nmds")
df.mds

### ## # ## ### ## # ## ### ## # ## ###

# Plot ----

## ggplot ----

df.mds |> 
  mutate(rowname = rownames(df),
         cluster = as.factor(tree.cut)) |> # + grouping variable
  
  # plot
  ggplot(aes(x = D1, y = D2,
    label = rowname, color = cluster, shape = cluster)) +
  
  # plot points
  geom_point(size = 5, alpha = 1) +
  #scale_color_manual(values = viridis::viridis(n = max(tree.cut))) +
  scale_color_manual(values = c("palegreen4", "deeppink1", "royalblue1")) +
  
  # plot text
  geom_text(col = 'grey10', size = 10, size.unit = 'pt') +
  # remove colour to inherit above values
  
  # plot theme
  theme_minimal() +
  labs(x = '', y = '', # removes axis titles
       color = "Cluster", shape = "Cluster") + # in case you include the legend
  theme(legend.position = '') # removes legend

### ## # ## ### ## # ## ### ## # ## ###
