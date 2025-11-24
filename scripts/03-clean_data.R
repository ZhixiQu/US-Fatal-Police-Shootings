#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
library(lubridate)
library(readxl)
library(forcats)
library(dplyr)

#### Clean data ####
# path
wapo_events_csv <- "data/01-raw_data/fatal-police-shootings-data.csv"
nst_2020_xlsx <- "data/01-raw_data/nst-est2020.xlsx"
nst_2024_xlsx <- "data/01-raw_data/NST-EST2024-POP.xlsx"

data_2020 <- read_excel(nst_2020_xlsx, skip = 9, col_names = FALSE)
colnames(data_2020) <- c("State","a", "b", "c","d", "e", "f", "g", "Population_2015",
                         "Population_2016", "Population_2017", "Population_2018", 
                         "Population_2019", "h", "i")
data_2020 <- data_2020 %>%
  dplyr::select(State, Population_2015, Population_2016, Population_2017, Population_2018, 
                Population_2019)

data_2024 <- read_excel(nst_2024_xlsx, skip = 9, col_names = FALSE)
colnames(data_2024) <- c("State","a", "Population_2020","Population_2021", 
                         "Population_2022", "Population_2023", "Population_2024")
data_2024 <- data_2024 %>%
  dplyr::select(State, Population_2020, Population_2021, Population_2022, 
                Population_2023, Population_2024)
state_map <- tibble(NAME  = c(state.name, "District of Columbia"),
                    state = c(state.abb, "DC")
)

# combine 2 xlsx
to_long <- function(df) {
  df %>%
    mutate(NAME = str_remove(State, "^\\.")) %>%
    inner_join(state_map, by = "NAME") %>%
    dplyr::select(state, starts_with("Population_")) %>%
    pivot_longer(-state, names_to = "var", values_to = "pop") %>%
    mutate(year = as.integer(str_extract(var, "\\d{4}")), pop = as.numeric(pop)
    ) %>%
    dplyr::select(state, year, pop) %>%
    arrange(state, year)
}

long_2020 <- to_long(data_2020)
long_2024 <- to_long(data_2024)
state_year_pop <- bind_rows(long_2020, long_2024) %>%
  filter(year >= 2015, year <= 2024) %>%
  group_by(state, year) %>%
  summarise(pop = first(pop), .groups = "drop") %>%
  arrange(state, year)

######### For graph(risk for years and states) ######
# transfer to year and filter year between 2015 and 2024
police_shoot <- read_csv(wapo_events_csv, show_col_types = FALSE) %>%
  mutate(date = ymd(date), year = year(date)) %>%
  filter(!is.na(year), year >= 2015, year <= 2024) %>%
  distinct(id, .keep_all = TRUE)
# find num of death and group by state and year to combine with state_year_pop.csv
state_year_deaths <- police_shoot %>%
  group_by(state, year) %>%
  summarise(deaths = n(), .groups = "drop")
# fatal police shootings rate per 1 million population(risk)
population_data <- state_year_pop
state_year_rates <- state_year_deaths %>%
  right_join(population_data, by = c("state","year")) %>%
  mutate(
    deaths = replace_na(deaths, 0L),
    rate_per_million = deaths/pop*1000000,
    log_pop = log(pop)
  ) %>%
  arrange(state, year)

######## For Logistic Regression-Body Camera #####
# race = sub(";.*$", "", race) only take first race
logistic_data <- police_shoot %>%
  mutate(body_camera_binary = case_when(body_camera == TRUE  ~ 1, 
                                        body_camera == FALSE ~ 0, TRUE ~ NA), 
         race = if_else(is.na(race), "Unknown", race), race = sub(";.*$", "", race),
         gender = if_else(is.na(gender), "Unknown", gender), age = as.numeric(age), 
         age_group = cut(age, breaks = c(0, 17, 29, 44, 59, Inf),
                         labels = c("Under 18", "18–29", "30–44", "45–59", "60+"),
                         include.lowest = TRUE, right = TRUE), 
         armed = case_when(armed_with %in% c("unarmed", "replica", "undetermined")
                           ~"no", is.na(armed_with) ~ "Unknown",
                           TRUE ~ "yes"),
         flee = case_when(flee_status == "not" ~ "no", !is.na(flee_status) ~ "yes", 
                          TRUE ~ "Unknown"),
         whether_mental_ill = case_when( was_mental_illness_related == TRUE  ~ "yes",
                                         was_mental_illness_related == FALSE ~ "no",
                                         TRUE ~ "Unknown"
         ))%>%
  filter(!is.na(body_camera_binary), !is.na(age_group))%>%
  dplyr::select(id, state, year, age_group, gender, race, whether_mental_ill, 
                armed, flee, body_camera_binary)

#### Save data ####
write_csv(state_year_rates, "data/02-analysis_data/state_year_rates.csv")
write_csv(logistic_data, "data/02-analysis_data/logistic_data.csv")
