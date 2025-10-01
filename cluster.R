#' @title: Cluster for SEER
#' @author: Dean A. Erasmus
#' @description
#' Cluster Diagram for Soil Ecology and Entomology Research lab.
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
