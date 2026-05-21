#' @title: PCoA for SEER
#' @author: Dean A. Erasmus
#' @description
#' Principal Coordinate Analysis for Soil Ecology and Entomology Research lab.

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

# PCoA: Bray-Curtis ----------------

# calculate distance matrix first (required for PCoA)
dune_dist_bc <- vegdist(dune, method = 'bray')

dune_pcoa <- wcmdscale( # performs PCoA (weighted classical MDS)
  dune_dist_bc, # distance matrix
  k = 2, # number of intended dimensions (X and Y)
  eig = TRUE # return eigenvalues to calculate variance explained
)

# default plot
plot(dune_pcoa)

## PCoA plot data ----------------

# calculate variance explained per axis
pcoa_bc_vars <- round(100 * (dune_pcoa$eig / sum(dune_pcoa$eig)), 1)
pcoa_bc_vars[1:2] # percentage explained by Axis 1 and 2

# PCoA points + environmental variables
# order must be conserved (ID) to reliably join these data
dune_pcoa.df <- as_tibble(dune_pcoa$points) |> 
  bind_cols(dune.env) |>
  rownames_to_column('ID') |> 
  mutate(Method = 'Bray-Curtis') |> 
  rename(PCoA1 = Dim1, PCoA2 = Dim2)

dune_pcoa.df

## PCoA plot ----

dune_pcoa.gg <- dune_pcoa.df |> 
  
  # plot
  ggplot(aes(x = PCoA1, y = PCoA2, label = ID,
    shape = Management, colour = Management)) +
  
  # plot points
  geom_point(size = 5, alpha = 1) +
  scale_shape_manual(values = c(15, 16, 17, 18)) + # 4 management levels
  scale_color_viridis_d(option = 'D') +
  
  # plot text
  geom_text(col = 'black', size = 10, size.unit = 'pt',
    nudge_y = 0.02, nudge_x = 0) + # adjusted nudge for PCoA coordinate scale
  # remove colour to inherit above values
  
  # plot theme and axes
  labs(
    x = paste0("PCoA1 (", pcoa_bc_vars[1], "%)"),
    y = paste0("PCoA2 (", pcoa_bc_vars[2], "%)"),
    color = "Management", 
    shape = "Management"
  ) + 
  theme_minimal() +
  theme(legend.position = 'right')

dune_pcoa.gg # view plot

# save file as svg
ggsave(
  filename = 'plots/pcoa.svg', # file name and path
  plot = dune_pcoa.gg, # plot object to save
  width = 2048, height = 1536, # plot dimensions
  units = 'px', # units of plot dimensions (px = pixel)
  bg = 'transparent' # background colour (can be white)
)

# PCoA: Bray-Curtis + Jaccard ----------------

# Jaccard data
dune_dist_j <- vegdist(dune, method = 'jaccard')

dune_pcoa_j <- wcmdscale( 
  dune_dist_j, 
  k = 2, 
  eig = TRUE 
)

pcoa_j_vars <- round(100 * (dune_pcoa_j$eig / sum(dune_pcoa_j$eig)), 1)

# PCoA points
dune_pcoa.df_j <- as.data.frame(dune_pcoa_j$points) |> 
  bind_cols(dune.env) |>
  rownames_to_column('ID') |> 
  mutate(Method = 'Jaccard') |> 
  rename(PCoA1 = Dim1, PCoA2 = Dim2)

## Bray-Curtis + Jaccard plot data ----------------

dune_pcoa.df_new <- bind_rows(dune_pcoa.df, dune_pcoa.df_j)

## PCoA plot with 2 methods ----------------

dune_pcoa.gg_new <- dune_pcoa.df_new |> 
  
  # plot
  ggplot(aes(x = PCoA1, y = PCoA2, label = ID,
    shape = Management, colour = Method)) +

  # plot points
  geom_point(size = 5, alpha = 0.75) +
  scale_shape_manual(values = c(15, 16, 17, 18)) + # 4 management levels

  # plot theme and axes
  labs(
    x = "PCoA1", 
    y = "PCoA2", 
    color = "Method", # Corrected to mirror the mapped aesthetic mapping
    shape = "Management" 
  ) + 
  theme_minimal() +
  theme(legend.position = 'right')

dune_pcoa.gg_new # view plot

# save file as svg
ggsave(
  filename = 'plots/pcoa_BCJ.svg', # file name and path
  plot = dune_pcoa.gg_new, # plot object to save
  width = 2048, height = 1536, # plot dimensions
  units = 'px', # units of plot dimensions (px = pixel)
  bg = 'transparent' # background colour (can be white)
)

# save objects ----------------

save(dune_pcoa.gg, dune_pcoa.gg_new, file = 'R/pcoa_plots')
