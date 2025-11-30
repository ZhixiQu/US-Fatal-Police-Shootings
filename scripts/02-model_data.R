#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
logistic_data <- read_csv("data/02-analysis_data/logistic_data.csv")

### Model data ####
set.seed(1008273333)
logistic_data = logistic_data %>%
  mutate(race = factor(race), gender = factor(gender), 
         age_group = factor(age_group), armed = factor(armed), 
         flee = factor(flee), whether_mental_ill = factor(whether_mental_ill))
model = stan_glm(body_camera_binary ~ gender + age_group + flee + 
                   whether_mental_ill + year + race*armed,
                 data = logistic_data, family = binomial(link = "logit"),
                 prior = normal(0, 2.5, autoscale = FALSE),
                 prior_intercept = normal(0, 2.5, autoscale = FALSE),
                 chains = 4, iter = 2000, seed = 1008273333)
summary(model, probs = c(0.05, 0.95))


#### Save model ####
saveRDS(model, file = "models/first_model.rds")


