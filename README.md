# Guide to Ecological Community Analysis

Methods covered:

- [Principle Component Analysis (PCA)](#pca)
- Multidimensional Scaling
  - parametric (MDS)
  - non-parametric (NMDS)

## Dataset

The dataset `protein.csv` is the protein consumption of various European countries.

After reading in the dataset you will process it at least two ways:

1. Tidy
2. Standardise

Tidying the data means ensuring the dataset will run smoothly through the functions. Here I pipe (`|>`) together the tidying and standardising functions. Firstly, I set the `Country` column to the rownames. This removes the column from the analysis and indicates the values that will be mapped in the ordination plots. Secondly, I select the variables that I want in the plot. Note, I indicate that the `select` function is from the `dplyr` package as the `MASS` package also has a `select` function. This can be omitted if 

## Unsupervised

### PCA

*To Do*

### MDS

*To Do*

- [NMDS Plots in R by Jackie Zorz](https://jkzorz.github.io/2019/06/06/NMDS.html)

### Cluster

*To Do*

## Supervised

### ANOSIM

*To Do*

## To Do

- [ ] Technique explanations
- [ ] Add cluster analysis
- [ ] Add ANOSIM
- [ ] Expanded figure customisation
- [ ] Add table presentation for RMarkdown
- [ ] Improve biplot in PCA script
