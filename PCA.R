#' title: Principle Component Analysis for SEER
#' author: Dean Erasmus 

## Setup ----

rm(list = ls())

setwd()

# packages

library(tidyverse)
library(MASS)
library(smacof)
library(cluster)
library(ggdendro)
library(ggfortify)
library(vegan)

## Data ----

data <- read_csv("protein.csv")

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

# Correlation Matrix

var(df)

## PCA ----

pca <- princomp(df, cor = T, scores = T, fix_sign = T)

## PC loadings
# ßxr, where k is the
pca$loadings

## PC scores
pca$scores

## rank
pc1.rank <- tibble("scores" = pca$scores[,1], "rank" = rank(pca$scores[,1]))

## proportion of variation of first 2 eigen values
sum(pca$sdev[1:2])/sum(pca$sdev)

## PCA Plot ----

autoplot(pca, data = data, 
         # Labels
         label = TRUE, label.size = 3, colour = "black",
         # Shapes
         shape = 16, # can be FALSE
         # Loadings
         loadings.label = TRUE, loadings.colour = "cyan", 
         loadings.label.size = 2, loadings.label.colour = "cyan") +
  theme_minimal()

## Biplot ----

# base package

biplot(pca)

# custom function

source(file = "/Users/deanerasmus/My Drive/xy/functions/PCAbiplot.R")
PCAbiplot(df, scaled.mat = T)

## Scree Plot ----

plot(svd(df)$d^2, type = 'b')
