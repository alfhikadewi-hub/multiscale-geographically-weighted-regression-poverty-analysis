#====================================================
# SPATIAL POVERTY ANALYSIS IN KALIMANTAN
# MGWR APPROACH
#====================================================

#====================================================
# LOAD LIBRARIES
#====================================================

library(sf)
library(readxl)
library(spdep)
library(GWmodel)
library(sp)
library(ggplot2)
library(AICcmodavg)

#====================================================
# IMPORT SPATIAL AND ATTRIBUTE DATA
#====================================================

setwd("D:/NEC")

kalim <- st_read("new-kabkot-kalimantan")

JPM <- read_excel("JPM .xlsx")

#====================================================
# DATA PREPROCESSING
#====================================================

# Convert region names to lowercase
kalim$WADMKK <- tolower(kalim$WADMKK)

JPM$`Kab/Kota` <- tolower(JPM$`Kab/Kota`)

# Harmonize inconsistent region names
JPM$`Kab/Kota`[
  JPM$`Kab/Kota` == "palangka raya"
] <- "kota palangkaraya"

JPM$`Kab/Kota`[
  JPM$`Kab/Kota` == "kota banjar baru"
] <- "kota banjarbaru"

JPM$`Kab/Kota`[
  JPM$`Kab/Kota` == "tarakan"
] <- "kota tarakan"

# Check unmatched region names
setdiff(
  JPM$`Kab/Kota`,
  kalim$WADMKK
)

#====================================================
# MERGE SPATIAL AND ATTRIBUTE DATA
#====================================================

kalim_data <- merge(
  kalim,
  JPM,
  by.x = "WADMKK",
  by.y = "Kab/Kota"
)

# Number of observations
nrow(kalim_data)

#====================================================
# VARIABLE TRANSFORMATION
#====================================================

kalim_data$logPDRB <- log(kalim_data$PDRB)

#====================================================
# CONVERT SF OBJECT TO SPATIAL OBJECT
#====================================================

kalim_sp <- as(
  kalim_data,
  "Spatial"
)

coords <- coordinates(kalim_sp)

#====================================================
# ORDINARY LEAST SQUARES (OLS)
#====================================================

ols_model <- lm(
  PPM ~ TPT + RLS + PDRB,
  data = kalim_sp@data
)

summary(ols_model)

AIC(ols_model)

AICc(ols_model)

#====================================================
# SPATIAL AUTOCORRELATION TEST
#====================================================

# Spatial weights matrix
nb <- poly2nb(kalim_data)

lw <- nb2listw(
  nb,
  style = "W",
  zero.policy = TRUE
)

# Moran's I test
moran.test(
  kalim_data$PPM,
  lw,
  zero.policy = TRUE
)

# Moran's I for OLS residuals
res_ols <- residuals(ols_model)

moran.test(
  res_ols,
  lw,
  zero.policy = TRUE
)

#====================================================
# MULTISCALE GEOGRAPHICALLY WEIGHTED REGRESSION
#====================================================

mgwr_model <- gwr.multiscale(
  
  formula = PPM ~ TPT + RLS + logPDRB,
  
  data = kalim_sp,
  
  kernel = "bisquare",
  
  adaptive = TRUE,
  
  criterion = "AICc",
  
  verbose = TRUE
)

mgwr_model

#====================================================
# LOCAL COEFFICIENTS
#====================================================

hasil_mgwr <- as.data.frame(
  mgwr_model$SDF
)

head(hasil_mgwr)

#====================================================
# ADD LOCAL COEFFICIENTS TO SPATIAL DATA
#====================================================

kalim_data$Intercept <- hasil_mgwr$`(Intercept)`

kalim_data$Koef_TPT <- hasil_mgwr$TPT

kalim_data$Koef_RLS <- hasil_mgwr$RLS

kalim_data$Koef_logPDRB <- hasil_mgwr$logPDRB

#====================================================
# VISUALIZATION OF LOCAL COEFFICIENTS
#====================================================

# TPT Coefficient Map
ggplot(kalim_data) +
  
  geom_sf(
    aes(fill = Koef_TPT),
    color = "white",
    size = 0.2
  ) +
  
  scale_fill_gradient(
    low = "yellow",
    high = "darkred",
    name = "TPT Coefficient"
  ) +
  
  labs(
    title = "Local Coefficient of TPT",
    subtitle = "MGWR Model"
  ) +
  
  theme_void() +
  
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold"
    ),
    
    plot.subtitle = element_text(
      hjust = 0.5
    )
  )

# RLS Coefficient Map
ggplot(kalim_data) +
  
  geom_sf(
    aes(fill = Koef_RLS),
    color = "white",
    size = 0.2
  ) +
  
  scale_fill_gradient(
    low = "yellow",
    high = "darkred",
    name = "RLS Coefficient"
  ) +
  
  labs(
    title = "Local Coefficient of RLS",
    subtitle = "MGWR Model"
  ) +
  
  theme_void()

# PDRB Coefficient Map
ggplot(kalim_data) +
  
  geom_sf(
    aes(fill = Koef_logPDRB),
    color = "white",
    size = 0.2
  ) +
  
  scale_fill_gradient(
    low = "yellow",
    high = "darkred",
    name = "PDRB Coefficient"
  ) +
  
  labs(
    title = "Local Coefficient of PDRB",
    subtitle = "MGWR Model"
  ) +
  
  theme_void()

#====================================================
# LOCAL SIGNIFICANCE TEST
#====================================================

kalim_data$t_TPT <- hasil_mgwr$TPT_TV

kalim_data$t_RLS <- hasil_mgwr$RLS_TV

kalim_data$t_logPDRB <- hasil_mgwr$logPDRB_TV

# Significant variables
kalim_data$Sig_TPT <- abs(kalim_data$t_TPT) > 1.96

kalim_data$Sig_RLS <- abs(kalim_data$t_RLS) > 1.96

kalim_data$Sig_PDRB <- abs(kalim_data$t_logPDRB) > 1.96

#====================================================
# GROUPING SIGNIFICANT VARIABLES
#====================================================

kalim_data$Kelompok <- ""

for(i in 1:nrow(kalim_data)){
  
  sig_var <- c()
  
  if(kalim_data$Sig_TPT[i]){
    sig_var <- c(sig_var, "TPT")
  }
  
  if(kalim_data$Sig_RLS[i]){
    sig_var <- c(sig_var, "RLS")
  }
  
  if(kalim_data$Sig_PDRB[i]){
    sig_var <- c(sig_var, "PDRB")
  }
  
  kalim_data$Kelompok[i] <- paste(
    sig_var,
    collapse = ", "
  )
}

# Significant variables by region
data.frame(
  Wilayah = kalim_data$WADMKK,
  Variabel_Signifikan = kalim_data$Kelompok
)

#====================================================
# MGWR EQUATION FOR EACH REGION
#====================================================

model_mgwr <- paste0(
  
  "Ŷ = ",
  
  round(hasil_mgwr$Intercept, 4),
  
  ifelse(hasil_mgwr$TPT >= 0, " + ", " - "),
  abs(round(hasil_mgwr$TPT, 4)),
  "TPT",
  ifelse(abs(hasil_mgwr$TPT_TV) > 1.96, "*", ""),
  
  ifelse(hasil_mgwr$RLS >= 0, " + ", " - "),
  abs(round(hasil_mgwr$RLS, 4)),
  "RLS",
  ifelse(abs(hasil_mgwr$RLS_TV) > 1.96, "*", ""),
  
  ifelse(hasil_mgwr$logPDRB >= 0, " + ", " - "),
  abs(round(hasil_mgwr$logPDRB, 4)),
  "logPDRB",
  ifelse(abs(hasil_mgwr$logPDRB_TV) > 1.96, "*", "")
)

tabel_model <- data.frame(
  
  No = 1:nrow(kalim_data),
  
  Wilayah = tools::toTitleCase(
    kalim_data$WADMKK
  ),
  
  Model_MGWR = model_mgwr
)

tabel_model