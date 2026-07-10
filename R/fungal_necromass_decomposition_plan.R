# fungal necromass decomposition plan

library(targets)
library(tarchetypes)

source("R/functions/fungal_necromass_decomposition_functions.R")

tar_option_set(packages = c("dataDownloader", "dataDocumentation",
                            "tidyverse", "janitor", "readxl"))

list(

  # get necromass bags weights pre burial
  tar_target(
    name = get_pre_burial_weights,
    command = get_file(
      node = "tx9r2",
      file = "FUNDER_raw_fungal_necromass_start_weights.xlsx",
      path = "raw_data/soil_carbon_and_nitrogen",
      remote_path = "xvii-xxiii_carbon_and_nutrient_cycling/xxii_fungal_necromass_decomposition/")
  ),

  # clean weights pre burial and make tag corrections
  tar_target(
    name = pre_burial_weights,
    command = clean_pre(data = get_pre_burial_weights)
  ),

  # get necromass bag weights post burial
  tar_target(
    name = get_post_burial_weights,
    command = get_file(
      node = "tx9r2",
      file = "FUNDER_mass_loss_2022 - fungal_necromass.csv",
      path = "raw_data/soil_carbon_and_nitrogen",
      remote_path = "xvii-xxiii_carbon_and_nutrient_cycling/xxii_fungal_necromass_decomposition/")
  ),

  # clean weights post burial and make tag corrections
  tar_target(
    name = post_burial_weights,
    command = clean_post(data = get_post_burial_weights)
  ),

  # combine pre and post weights and clean
  tar_target(
    name = post_comments,
    command = get_necromass_comments(post = post_burial_weights)
  ),

  # combine pre weights, post weights, and comments
  tar_target(
    name = fungal_necromass_decomposition,
    command = finish(pre = pre_burial_weights,
                     post = post_burial_weights,
                     comment = post_comments)
  )

)




# six samples are missing from the dataset:
# Fau2GB melanised and non-melanised, this plot has not been treated since 2017
# Ulv1B melanised and non-melanised, this plot is missing in all datasets
# Ovs1B melanised was not found the field
# Skj3GB non-melanised was not found in the field
