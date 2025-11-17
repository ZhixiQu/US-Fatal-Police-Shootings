# US Fatal Police Shootings Analysis

## Overview

This study analyzes changes in U.S. police shooting fatality rates during the 2015-2024 period. It further examines relationships between victim demographics (e.g., race, gender, age), incident characteristics (e.g., whether armed, threat level, whether fleeing), temporal and spatial factors (e.g., year, state or city), and whether police activated body cameras. This study utilizes data on fatal police shootings in the United States from 2015 to 2024, employing a Bayesian logistic regression model to analyze trends and key factors influencing whether U.S. police activate body cameras. The research contributes to a deeper exploration of potential inequities in police transparency within the United States, providing a reference for future U.S. police enforcement standards and ensure transparency and accountability in police operations.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from https://github.com/washingtonpost/data-police-shootings.git (police shooting data), https://www.census.gov/programs-surveys/popest/technical-documentation/research/evaluation-estimates/2020-evaluation-estimates/2010s-state-total.html (U.S. Census Bureau) and https://www.census.gov/data/tables/time-series/demo/popest/2020s-state-total.html (U.S. Census Bureau).
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.
