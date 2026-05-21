#' @title: NMDS for SEER
#' @author: Dean A. Erasmus
#' @description
#' Non-metric Multidimensional Scaling for Soil Ecology and Entomology Research lab.

# setup ----------------

rm(list = ls())
getwd()

# packages
library(tidyverse)
library(vegan)

# data ----------------

# abundances; sample data; taxonomic data
data(dune); data(dune.env); data(dune.taxon)

# conserve the order of the data for joining later

# NMDS: Bray-Curtis ----------------

dune_mds <- metaMDS( # performs NMDS
  dune, # community data
  distance = 'bray', # Bray-Curtis is the standard for community abundances
  k = 2 # number of intended dimensions (X and Y)
)

# default plot
plot(dune_mds)

## NMDS plot data ----------------

dune_mds$stress # stress is important to report
dune_mds$points # this is what we want to plot

# NMDS points + environmental variables
# order must be conserved (ID) to reliably join these data
dune_mds.df <- bind_cols(dune_mds$points, dune.env) |>
  rownames_to_column('ID') |> 
  mutate(Method = 'Bray-Curtis') |> 
  rename(NMDS1 = MDS1, NMDS2 = MDS2)

dune_mds.df

## NMDS plot ----

dune_mds.gg <- dune_mds.df |> 
  
  # plot
  ggplot(aes(x = NMDS1, y = NMDS2, label = ID,
    shape = Management, colour = Management)) +
  
  # plot points
  geom_point(size = 5, alpha = 1) +
  scale_shape_manual(values = c(15, 16, 17, 18)) + # 4 management levels
  scale_color_viridis_d(option = 'D') +
  
  # plot text
  geom_text(col = 'black', size = 10, size.unit = 'pt',
    nudge_y = 0.1, nudge_x = 0) + # reposition the text above/below (y) or left/right (x)
  # remove colour to inherit above values
  
  # stress value
  annotate('text', x = 0.75, y = 1.0, # manually select position of the text
    label = paste('Stress: ', round(dune_mds$stress, 3))) +

  # plot theme and axes
  labs(color = "Management", shape = "Management") + # for legend
  theme_minimal() +
  theme(legend.position = 'right') # blank removes legend, else: bottom, top, left, or right

dune_mds.gg # view plot

# save file as svg
ggsave(
  filename = 'plots/nmds.svg', # file name and path
  plot = dune_mds.gg, # plot object to save
  width = 2048, height = 1536, # plot dimensions
  units = 'px', # units of plot dimensions (px = pixel)
  bg = 'transparent' # background colour (can be white)
)

# NMDS: Bray-Curtis + Jaccard ----------------

# Jaccard data
dune_mds_j <- metaMDS( # performs NMDS
  dune, # community data
  distance = 'jaccard', #
  k = 2 # number of intended dimensions (X and Y)
)

dune_mds_j$stress
dune_mds_j$points

# NMDS points
dune_mds.df_j <- bind_cols(dune_mds_j$points, dune.env) |>
  rownames_to_column('ID') |> 
  mutate(Method = 'Jaccard') |> 
  rename(NMDS1 = MDS1, NMDS2 = MDS2)

## Bray-Curtis + Jaccard plot data ----------------

dune_mds.df_new <- bind_rows(dune_mds.df, dune_mds.df_j)

## NMDS plot with 2 methods ----------------

dune_mds.gg_new <- dune_mds.df_new |> 
  
  # plot
  ggplot(aes(x = NMDS1, y = NMDS2, label = ID,
    shape = Management, colour = Method)) +

  # plot points
  geom_point(size = 5, alpha = 0.75) +
  scale_shape_manual(values = c(15, 16, 17, 18)) + # 4 management levels

  # plot theme and axes
  labs(color = "Management", shape = "Method") + # for legend
  theme_minimal() +
  theme(legend.position = 'right') # blank removes legend, else: bottom, top, left, or right

dune_mds.gg_new # view plot

# save file as svg
ggsave(
  filename = 'plots/nmds_BCJ.svg', # file name and path
  plot = dune_mds.gg_new, # plot object to save
  width = 2048, height = 1536, # plot dimensions
  units = 'px', # units of plot dimensions (px = pixel)
  bg = 'transparent' # background colour (can be white)
)

# save objects ----------------

save(dune_mds.gg, dune_mds.gg_new, file = 'R/nmds_plots')
