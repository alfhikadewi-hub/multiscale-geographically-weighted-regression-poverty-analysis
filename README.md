# Spatial Poverty Analysis in Kalimantan using MGWR

## Overview
This project analyzes spatial heterogeneity of poverty factors across districts/cities in Kalimantan using Multiscale Geographically Weighted Regression (MGWR).

The analysis investigates how unemployment, education, and regional economic indicators affect poverty differently across regions.

---

## Objectives
- Analyze spatial patterns of poverty in Kalimantan
- Detect spatial autocorrelation using Moran’s I
- Compare global and local regression approaches
- Identify locally significant poverty factors using MGWR

---

## Variables

### Dependent Variable
- Poverty Percentage (PPM)

### Independent Variables
- Open Unemployment Rate (TPT)
- Average Years of Schooling (RLS)
- Gross Regional Domestic Product (PDRB)

---

## Methods
The analysis includes:

1. Spatial data preprocessing
2. Data integration using `sf`
3. Ordinary Least Squares (OLS)
4. Spatial autocorrelation test (Moran’s I)
5. Multiscale Geographically Weighted Regression (MGWR)
6. Local coefficient visualization

---

## Libraries
```r
sf
spdep
GWmodel
ggplot2
tidyverse
car
lmtest
AICcmodavg
readxl
```

---

## Outputs
- Moran’s I statistics
- OLS model summary
- MGWR local coefficients
- Significance mapping
- Spatial visualization of local effects

---

## Visualization
This project produces spatial coefficient maps for:
- TPT
- RLS
- PDRB

using `ggplot2` and spatial polygon data.

---

## Author
A. Alfhika Aulia Dewi
Statistics Student | Data, Machine Learning, and AI Enthusiast
