#' @title: Plot Plates for SEER
#' @author: Dean A. Erasmus
#' @description
#' Binding Plots for Soil Ecology and Entomology Research lab.

# setup ----------------

rm(list = ls())
getwd()

# packages
library(tidyverse)
library(gridExtra)
library(cowplot)

# data ----------------

load('R/nmds_plots')
load('R/pcoa_plots')

# plot grid ----------------

dune_legend <- get_legend(dune_pcoa.gg_new)

dune.gg_grid <- grid.arrange(
  dune_mds.gg_new + theme(legend.position = 'none'),
  dune_pcoa.gg_new + theme(legend.position = 'none'),
  dune_legend,
  ncol = 3, widths = c(1, 1, 0.3))

# save grid ----------------

ggsave(
  filename = 'plots/nmds_pcoa.svg', # file name and path
  plot = dune.gg_grid, # plot object to save
  width = 2560, height = 1024, scale = 2, # plot dimensions
  units = 'px', # units of plot dimensions (px = pixel)
  bg = 'transparent' # background colour (can be white)
)
