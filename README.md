# Spatial Poverty Analysis in Kalimantan using MGWR

## Overview
Poverty remains one of the major socio-economic challenges in Kalimantan. Although overall development has improved, poverty levels still vary considerably across districts and cities, indicating spatial heterogeneity. This project applies Multiscale Geographically Weighted Regression (MGWR) to investigate how education, unemployment, and regional economic performance influence poverty differently across locations. The study is based on data from 56 districts/cities in Kalimantan (2025).

---

## Objectives
- Explore the spatial distribution of poverty across Kalimantan.
- Detect spatial autocorrelation using Moran's I.
- Compare Ordinary Least Squares (OLS) and MGWR models.
- Estimate local regression coefficients for each district.
- Identify region-specific determinants of poverty.
- Provide evidence-based policy recommendations.

---

## Dataset
### Source
- Central Bureau of Statistics Republic of Indonesia (BPS)
- Administrative boundary shapefile of Kalimantan
### Observation Unit
- 56 districts/cities
### Year
- 2025

## Variables

### Dependent Variable
- Poverty Percentage (PPM)

### Independent Variables
- Open Unemployment Rate (TPT)
- Average Years of Schooling (RLS)
- Gross Regional Domestic Product (PDRB)

---

## Methodology
The analysis follows the workflow below:
```mermaid
flowchart LR
    A[Data Collection] --> B[Data Cleaning and Integration]
    B --> C[Exploratory Spatial Analysis]
    C --> D[OLS]
    D --> E[Spatial Weight Matrix]
    E --> F[Moran Test]
    F --> G[MGWR Modeling]
    G --> H[Model Evaluation]
    H --> I[Local Coefficient Mapping]
```


---

## Tools & Libraries
### Programming Language
RStudio
### Libraries
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

## Key Findings
- Significant positive spatial autocorrelation was detected using Moran's I (0.1718, p = 0.0187), indicating that neighboring districts tend to exhibit similar poverty levels.
- MGWR substantially outperformed the global OLS model.
- Average Years of Schooling (RLS) consistently showed a negative relationship with poverty.
- The effects of unemployment (TPT) and regional GDP (PDRB) varied across districts.
- Local regression coefficients revealed substantial spatial heterogeneity, supporting the use of MGWR for regional poverty analysis.
  
---
## Model Performance

---

## Outputs
- Spatial Poverty Map
- Moran's I Analysis
- OLS Regression Summary
- MGWR Model
- Local Coefficient Maps
- Significant Variable Classification
- Policy Recommendation

---


