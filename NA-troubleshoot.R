#' @title NA Troubleshooting
#' @author Dean A. Erasmus
#' @description
#' Troubleshoot NAs in your data frame. Convert them to zeroes.
#' 

# Setup ----

rm(list = ls())
getwd()

# packages
library(tidyverse)

### ## # ## ### ## # ## ### ## # ## ###

# Data ----

# matrix with NAs instead of zeroes

values <- c(1:5, NA)

mat_na <- matrix(data = sample(values, 40, replace = T), ncol = 4)

mat_na
# see NAs

# Base: NA <- 0 ----

mat_zero <- mat_na
mat_zero[is.na(mat_zero)] <- 0
mat_zero

# Tidyverse: NA <- 0 ----
# I prefer this method when working in a data frame as
# some columns aren't numeric

# add sample column

mat_zero <- mat_na |>
  as_tibble() |> 
  mutate(S = c(rep('A', 5), rep('B', 5))) |> 
  
  # all columns (don't use when you have a sample/site column)
  #mutate(across(everything(), ~replace_na(as.numeric(.), 0)))
  
  # select specific columns
  #mutate(across(V1:V4, ~replace_na(as.numeric(.), 0)))

  # select only numeric columns
  mutate(across(where(is.numeric), ~replace_na(as.numeric(.), 0)))

mat_zero

### ## # ## ### ## # ## ### ## # ## ###