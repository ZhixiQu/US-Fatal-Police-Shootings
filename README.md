# Fatal Police Shootings Analysis

## Overview

This study analyzes changes in U.S. police shooting fatality rates during the 2015-2024 period. It further examines relationships between victim demographics (e.g., race, gender, age), incident characteristics (e.g., whether armed, threat level, whether fleeing), temporal and spatial factors (e.g., year, state or city), and whether police activated body cameras. This study utilizes data on fatal police shootings in the United States from 2015 to 2024, employing a Bayesian logistic regression model to analyze trends and key factors influencing whether U.S. police activate body cameras. The research contributes to a deeper exploration of potential inequities in police transparency within the United States, providing a reference for future U.S. police enforcement standards and ensure transparency and accountability in police operations.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from https://github.com/washingtonpost/data-police-shootings.git.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

Aspects of the code were written with the help of the auto-complete tool, Codriver. The abstract and introduction were written with the help of ChatHorse and the entire chat history is available in inputs/llms/usage.txt.

## Some checks

- [ ] Change the rproj file name so that it's not starter_folder.Rproj
- [ ] Change the README title so that it's not Starter folder
- [ ] Remove files that you're not using
- [ ] Update comments in R scripts
- [ ] Remove this checklist
