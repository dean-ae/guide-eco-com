#' @title: Cluster for SEER
#' @author: Dean A. Erasmus
#' @description
#' Cluster Dendrograms for Soil Ecology and Entomology Research lab.
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

# abundances; sample data; taxonomic data
data(dune); data(dune.env); data(dune.taxon)

# conserve the order of the data for joining later

dune.env <- dune.env |> rownames_to_column('label')

### ## # ## ### ## # ## ### ## # ## ###

# Dissimilarity Matrix ----

dune_dist <- dune |> vegdist(method = 'bray')

plot(dune_dist |> sort())

### ## # ## ### ## # ## ### ## # ## ###

# Dendrogram ----

dune_tree <- hclust(dune_dist)

## Simple Tree ----

dune_tree.gg <- ggdendrogram(dune_tree)
dune_tree.gg

## Add Labels ----

dune_tree.gg <- as.dendrogram(dune_tree) |> 
  dendro_data(type = 'rectangle')

dune_tree.gg$labels <- dune_tree.gg$labels |> 
  left_join(dune.env, by = 'label')

## Complex Tree ----

tree.gg <- ggplot() +
  geom_segment(data = dune_tree.gg$segments,
               aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_text(data = dune_tree.gg$labels,
            aes(x = x, y = y - 0.05, label = label, colour = Management),
            angle = 0, hjust = 0.5, size = 3) +
  labs(title = 'Bray-Curtis distance') +
  theme_void()

tree.gg

# save file as svg
ggsave(filename = 'plots/tree.svg', plot = tree.gg,
       width = 2048, height = 1536, units = 'px', bg = 'white')

### ## # ## ### ## # ## ### ## # ## ###

# Tree Cut ----

# TO DO

# clusters
tree.cut <- cutree(tree, k = 4) # cut tree into k clusters
tree.cut <- data.frame(cluster = as.numeric(tree.cut), ID = names(tree.cut))

tree.cut

# add clusters
mds.df_cluster <- mds.df |> left_join(tree.cut, by = 'ID') |> 
  mutate(cluster = as.factor(cluster))

### ## # ## ### ## # ## ### ## # ## ###