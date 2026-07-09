# soil carbon and nitrogen plan

library(targets)
library(tarchetypes)

source("R/functions/clean_soil_cn.R")

tar_option_set(packages = c("dataDownloader", "dataDocumentation",
                            "tidyverse", "janitor", "readxl", "purrr"))

list(

  # the soil CN data are in four separate excel sheets on OSF:
  tar_target(
    name = cn1,
    command = get_file(
      node = "tx9r2",
      file = "24256_CN_EA_PeterF_B1_241106_report.xlsx",
      path = "raw_data/soil_carbon_and_nitrogen",
      remote_path = "xxi_soil_carbon_and_nitrogen/")
  ),

  tar_target(
    name = cn2,
    command = get_file(
      node = "tx9r2",
      file = "24256_CN_EA_PeterF_B2_241107_report.xlsx",
      path = "raw_data/soil_carbon_and_nitrogen",
      remote_path = "xxi_soil_carbon_and_nitrogen/")
  ),

  tar_target(
    name = cn3,
    command = get_file(
      node = "tx9r2",
      file = "24256_CN_EA_PeterF_B3_241108_report.xlsx",
      path = "raw_data/soil_carbon_and_nitrogen",
      remote_path = "xxi_soil_carbon_and_nitrogen/")
  ),

  tar_target(
    name = cn4,
    command = get_file(
      node = "tx9r2",
      file = "24256_CN_EA_PeterF_B4_241112_report.xlsx",
      path = "raw_data/soil_carbon_and_nitrogen",
      remote_path = "xxi_soil_carbon_and_nitrogen/")
  ),

  # clean and combine the CN sheets:

  tar_target(
    name = soil_cn,
    command = assemble_soil_cn(input = c(cn1, cn2, cn3, cn4))
  )

)
