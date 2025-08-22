# ==========================
# 1. Load Libraries
# ==========================
library(ggplot2)
library(agricolae)
library(dplyr)

# ==========================
# 2. Load Dataset
# ==========================
# Example dataset - replace with your own
df <- data.frame(
  Substance_Abuse = factor(rep(c(-1, 0, 1), each = 9)),
  Employment_Status = factor(rep(c(-1, 1), times = 13.5)),
  Population_Density = factor(rep(c(-1, 0, 1), times = 9)),
  Crime_Rate_per_1000 = rnorm(27, mean = 15, sd = 5)
)

# ==========================
# 3. Fit Three-way ANOVA
# ==========================
anova_model <- aov(Crime_Rate_per_1000 ~ Substance_Abuse * Employment_Status * Population_Density, data = df)
summary(anova_model)

# ==========================
# 4. Normality Test & Graphs
# ==========================
residuals_anova <- residuals(anova_model)

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

# ==========================
# 5. Main Effect Plots
# ==========================
# Substance Abuse
ggplot(df, aes(Substance_Abuse, Crime_Rate_per_1000)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Effect of Substance Abuse on Crime Rate",
       x = "Substance Abuse", y = "Crime Rate per 1000") +
  theme_minimal()

# Employment Status
ggplot(df, aes(Employment_Status, Crime_Rate_per_1000)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Effect of Employment Status on Crime Rate",
       x = "Employment Status", y = "Crime Rate per 1000") +
  theme_minimal()

# Population Density
ggplot(df, aes(Population_Density, Crime_Rate_per_1000)) +
  geom_boxplot(fill = "orange") +
  labs(title = "Effect of Population Density on Crime Rate",
       x = "Population Density", y = "Crime Rate per 1000") +
  theme_minimal()

# ==========================
# 6. Interaction Plots
# ==========================
# Two-way Interaction
interaction.plot(df$Substance_Abuse, df$Employment_Status, df$Crime_Rate_per_1000,
                 col = c("red", "blue"), lwd = 2,
                 ylab = "Mean Crime Rate per 1000",
                 xlab = "Substance Abuse", trace.label = "Employment Status")

interaction.plot(df$Substance_Abuse, df$Population_Density, df$Crime_Rate_per_1000,
                 col = c("purple", "green", "orange"), lwd = 2,
                 ylab = "Mean Crime Rate per 1000",
                 xlab = "Substance Abuse", trace.label = "Population Density")

interaction.plot(df$Employment_Status, df$Population_Density, df$Crime_Rate_per_1000,
                 col = c("brown", "blue", "pink"), lwd = 2,
                 ylab = "Mean Crime Rate per 1000",
                 xlab = "Employment Status", trace.label = "Population Density")

# Three-way Interaction
df %>%
  group_by(Substance_Abuse, Employment_Status, Population_Density) %>%
  summarise(mean_crime = mean(Crime_Rate_per_1000), .groups = "drop") %>%
  ggplot(aes(x = Substance_Abuse, y = mean_crime, color = Employment_Status, group = Employment_Status)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  facet_wrap(~ Population_Density) +
  labs(title = "Three-way Interaction Plot",
       y = "Mean Crime Rate per 1000", x = "Substance Abuse") +
  theme_minimal()

# ==========================
# 7. LSD Post Hoc Test
# ==========================
# If main effect is significant
lsd_substance <- LSD.test(anova_model, "Substance_Abuse", group = TRUE)
print(lsd_substance)

lsd_employment <- LSD.test(anova_model, "Employment_Status", group = TRUE)
print(lsd_employment)

lsd_population <- LSD.test(anova_model, "Population_Density", group = TRUE)
print(lsd_population)
