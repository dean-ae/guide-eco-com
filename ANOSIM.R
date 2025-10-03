#' @title: ANOSIM for SEER
#' @author: Dean A. Erasmus
#' @description
#' Analysis of Similarity for Soil Ecology and Entomology Research lab.
#' 

# Setup ----

rm(list = ls())
getwd()

# packages

library(tidyverse)
library(vegan)

### ## # ## ### ## # ## ### ## # ## ###

# Data ----

data(dune) # species abundance data
data(dune.env) # environmental data

head(dune)
head(dune.env)

### ## # ## ### ## # ## ### ## # ## ###

# Distance ----

dune.dist <- vegdist(dune, method = 'bray')

dune.dist

### ## # ## ### ## # ## ### ## # ## ###

# ANOSIM ----

dune.anosim <- anosim(dune.dist, dune.env$Management)

summary(dune.anosim)

plot(dune.anosim)

### ## # ## ### ## # ## ### ## # ## ###