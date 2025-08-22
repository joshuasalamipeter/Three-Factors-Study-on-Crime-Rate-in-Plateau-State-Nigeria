# Loading Packages
library(readxl)
library(ggplot2)
library(dplyr)
library(emmeans)
library(agricolae) # for LSD

# Loading Data
df <- read_excel("jos_crime_rate.xlsx")

# Convert to factors
df <- df %>%
  mutate(
    Substance_Abuse = as.factor(Substance_Abuse),
    Employment_Status = as.factor(Employment_Status),
    Population_Density = as.factor(Population_Density)
  )



# Fit ANOVA Model
model <- aov(Crime_Rate_per_1000 ~ Substance_Abuse * Employment_Status * Population_Density, data = df)

# ANOVA Table
anova_results <- summary(model)
print(anova_results)

# Normality Test & Graphs
residuals_anova <- residuals(model)

# Shapiro-Wilk Test
shapiro_test <- shapiro.test(residuals_anova)
print(shapiro_test)

# Histogram of Residuals
ggplot(data.frame(residuals_anova), aes(residuals_anova)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(title = "Histogram of ANOVA Residuals", x = "Residuals", y = "Frequency") +
  theme_minimal()

# Q-Q Plot
qqnorm(residuals_anova, main = "Q-Q Plot of ANOVA Residuals")
qqline(residuals_anova, col = "red", lwd = 2)


# Main Effect Plots

# Substance Abuse Effect
ggplot(df, aes(Substance_Abuse, Crime_Rate_per_1000)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Effect of Substance Abuse on Crime Rate",
       x = "Substance Abuse", y = "Crime Rate per 1000") +
  theme_minimal()

# Employment Status Effect
ggplot(df, aes(Employment_Status, Crime_Rate_per_1000)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Effect of Employment Status on Crime Rate",
       x = "Employment Status", y = "Crime Rate per 1000") +
  theme_minimal()

# Population Density Effect
ggplot(df, aes(Population_Density, Crime_Rate_per_1000)) +
  geom_boxplot(fill = "orange") +
  labs(title = "Effect of Population Density on Crime Rate",
       x = "Population Density", y = "Crime Rate per 1000") +
  theme_minimal()


# Interaction Plot (2-way)

interaction.plot(df$Substance_Abuse, df$Employment_Status, df$Crime_Rate_per_1000,
                 col = c("red", "blue"), lwd = 2,
                 ylab = "Mean Crime Rate per 1000",
                 xlab = "Substance Abuse", trace.label = "Employment Status")

interaction.plot(df$Substance_Abuse, df$Population_Density, df$Crime_Rate_per_1000,
                 col = c("red", "blue"), lwd = 2,
                 ylab = "Mean Crime Rate per 1000",
                 xlab = "Substance Abuse", trace.label = "Population Density")

interaction.plot(df$Employment_Status, df$Population_Density, df$Crime_Rate_per_1000,
                 col = c("red", "blue"), lwd = 2,
                 ylab = "Mean Crime Rate per 1000",
                 xlab = "Employment Status", trace.label = "Population Density")

# 3-Way Interaction Means
emm <- emmeans(model, ~ Substance_Abuse * Employment_Status * Population_Density)
plot(emm)


# LSD Post Hoc Tests

# Main Effects
print(LSD.test(model, "Substance_Abuse", p.adj = "none"))
print(LSD.test(model, "Employment_Status", p.adj = "none"))
print(LSD.test(model, "Population_Density", p.adj = "none"))

# Two-way Interactions
print(LSD.test(model, c("Substance_Abuse", "Employment_Status"), p.adj = "none"))
print(LSD.test(model, c("Substance_Abuse", "Population_Density"), p.adj = "none"))
print(LSD.test(model, c("Employment_Status", "Population_Density"), p.adj = "none"))

# Three-way Interaction
print(LSD.test(model, c("Substance_Abuse", "Employment_Status", "Population_Density"), p.adj = "none"))



