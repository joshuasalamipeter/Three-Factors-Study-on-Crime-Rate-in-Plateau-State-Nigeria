# 📊 Crime Rate Analysis Using ANOVA in R

[![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=R&logoColor=white)](https://www.r-project.org/)  
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## Overview
This R project analyzes the effects of **Substance Abuse**, **Employment Status**, and **Population Density** on crime rates per 1000 population in Jos, Nigeria. The analysis includes main effects, interactions, and post hoc comparisons using **ANOVA** and **LSD tests**.

---

## Features

- **Data Preparation**
  - Reads Excel dataset (`jos_crime_rate.xlsx`)
  - Converts categorical variables to factors.

- **ANOVA Analysis**
  - Three-way factorial ANOVA:
    ```r
    Crime_Rate_per_1000 ~ Substance_Abuse * Employment_Status * Population_Density
    ```
  - Summarizes main effects and interactions.

- **Assumption Checks**
  - Normality test (Shapiro-Wilk)
  - Histogram and Q-Q plot of residuals

- **Visualizations**
  - Boxplots for main effects
  - Two-way interaction plots
  - Three-way interaction plots using estimated marginal means

- **Post Hoc Analysis**
  - Least Significant Difference (LSD) tests for main effects, two-way, and three-way interactions

---

## Purpose
- Identify significant factors affecting crime rates
- Explore interaction effects between demographic and social factors
- Conduct post hoc comparisons to identify significantly different groups

---

## Getting Started

1. **Install Required Packages**
```r
install.packages(c("readxl", "ggplot2", "dplyr", "emmeans", "agricolae"))
