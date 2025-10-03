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

### ## # ## ### ## # ## ### ## # ## ###

# Data ----

# abundances; sample data; taxonomic data
data(dune); data(dune.env); data(dune.taxon)

# conserve the order of the data for joining later

### ## # ## ### ## # ## ### ## # ## ###

# MDS ----

# Bray-Curtis is the standard for community abundances
dune_mds <- metaMDS(dune, distance = 'bray')

# default plot
plot(dune_mds)

## MDS Plot Data ----

dune_mds$stress # this is important to report
dune_mds$points # this is what we want to plot

# MDS points + environmental variables
dune_mds.df <- bind_cols(dune_mds$points, dune.env) |> rownames_to_column('ID')
  
dune_mds.df

## MDS Plot ----

dune_mds.gg <- dune_mds.df |> 
  
  # plot
  ggplot(aes(x = MDS1, y = MDS2, label = ID,
             shape = Management, colour = Management)) +
  
  # plot points
  geom_point(size = 5, alpha = 1) +
  scale_shape_manual(values = c(15:(15+nlevels(dune_mds.df$Management)))) +
  scale_color_viridis_d(option = 'D') +
  
  # plot text
  geom_text(col = 'black', size = 10, size.unit = 'pt', nudge_y = 0.1) +
  # remove colour to inherit above values
  
  # stress value
  annotate('text', x = 0.75, y = 1.0,
           label = paste('Stress: ', round(dune_mds$stress, 3))) +

  # plot theme and axes
  labs(color = "Management", shape = "Management") + # for legend
  theme_minimal() +
  theme(legend.position = 'right') # blank removes legend, else: bottom, top, left, or right

dune_mds.gg

# save file as svg
ggsave(filename = 'plots/mds.svg', plot = dune_mds.gg,
       width = 2048, height = 1536, units = 'px', bg = 'white')

### ## # ## ### ## # ## ### ## # ## ###