#' @title: MDS for SEER
#' @author: Dean A. Erasmus
#' @description
#' Multidimensional Scaling for Soil Ecology and Entomology Research lab.
#' 

# Setup ----

rm(list = ls())
getwd()

# packages

library(tidyverse)
library(vegan)
library(ggdendro)
library(cluster)

### ## # ## ### ## # ## ### ## # ## ###

# Data ----

data <- read.csv("protein.csv")

head(data) # data is a matrix with n rows and p variables
plot(data) # shows relationships between all variables

## Standardise ----

df <- data |>
  # move identifier column to row names
  column_to_rownames(var = "Country") |>

  # scale values if measured differently
  decostand(method = "standardize")

head(df)

### ## # ## ### ## # ## ### ## # ## ###

# MDS ----

mds <- metaMDS(df, distance = 'euclidean')

plot(mds)

mds$points # this is what we want to plot

## Plot Data ----

mds.df <- mds$points |> 
  as.data.frame() |>
  rownames_to_column('ID') |> 
  as_tibble()

## Plot ----

mds.gg <- mds.df |> 
  
  # plot
  ggplot(aes(x = MDS1, y = MDS2, label = ID)) +
  
  # plot points
  geom_point(size = 5, alpha = 0.5) +
  #scale_color_manual(values = viridis::viridis(n = max(tree.cut))) +
  
  # plot text
  geom_text(col = 'grey10', size = 10, size.unit = 'pt', nudge_y = 0.25) +
  # remove colour to inherit above values
  
  # stress value
  annotate('text', x = 1, y = 4.5,
           label = paste('Stress: ', round(mds$stress, 2))) +

  # plot theme and axes
  labs(color = "Cluster", shape = "Cluster") + # in case you include the legend
  theme_minimal() +
  theme(legend.position = '') # removes legend; else + bottom, top, left, or right

mds.gg

# save file as svg
ggsave(filename = 'plots/mds.svg', plot = mds.gg,
       width = 2048, height = 2048, units = 'px')

## Add Clusters ----

### Clusters

# dendrogram
tree <- hclust(df |> vegdist(method = 'euclidean'))
tree.gg <- ggdendrogram(tree)
tree.gg

# save file as svg
ggsave(filename = 'plots/tree.svg', plot = tree.gg,
       width = 2048, height = 2048, units = 'px')

# clusters
tree.cut <- cutree(tree, k = 4) # cut tree into k clusters
tree.cut <- data.frame(cluster = as.numeric(tree.cut), ID = names(tree.cut))

tree.cut

# add clusters
mds.df_cluster <- mds.df |> left_join(tree.cut, by = 'ID') |> 
  mutate(cluster = as.factor(cluster))

### Plot + Cluster Labels ----

mds.gg_cluster <- mds.df_cluster |> 
  
  # plot
  ggplot(aes(x = MDS1, y = MDS2, label = ID, colour = cluster, shape = cluster)) +
  
  # plot points
  geom_point(size = 5, alpha = 0.75) +
  scale_color_manual(values = viridis::viridis(n = max(tree.cut$cluster))) +
  scale_shape_manual(values = c(15,16,17,18)) +
  
  # plot text
  geom_text(col = 'grey10', size = 10, size.unit = 'pt', nudge_y = 0.25) +
  
  # stress value
  annotate('text', x = 1, y = 4.5,
           label = paste('Stress: ', round(mds$stress, 2))) +
  
  # plot theme and axes
  labs(color = "Cluster", shape = "Cluster") + # in case you include the legend
  theme_minimal() +
  theme(legend.position = 'top')

mds.gg_cluster

# save file as svg
ggsave(filename = 'plots/mds_cluster.svg', plot = mds.gg_cluster,
       width = 2048, height = 2048, units = 'px')

### ## # ## ### ## # ## ### ## # ## ###
