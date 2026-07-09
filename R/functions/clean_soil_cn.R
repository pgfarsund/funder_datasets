#####################################################################
################ soil carbon and nitrogen functions #################
#####################################################################

# this cleans the sheets

clean_soil_cn <- function(data) {

  readxl::read_xlsx(data, sheet = 2) |>
    row_to_names(29) |>
    clean_names()

}

# this assembles the clean sheets into one dataset

assemble_soil_cn <- function(input) {
  rbind(purrr::map_df(input, clean_soil_cn)) |>
    filter(!is.na(identifier)) |>
    rename(
      plotID = cust_id_1,
      C = o_c_percent,
      N = o_n_percent,
      CN_ratio = c_n_ratio
    ) |>
    mutate(
      C = round(as.numeric(C), 2),
      N = round(as.numeric(N), 2),
      CN_ratio = round(as.numeric(CN_ratio), 2),
      siteID = substr(plotID, 1, 3),
      siteID = recode_values(
        siteID,
        "Gud" ~ "Gudmedalen",
        "Lav" ~ "Lavisdalen",
        "Ram" ~ "Rambera",
        "Ulv" ~ "Ulvehaugen",
        "Skj" ~ "Skjelingahaugen",
        "Alr" ~ "Alrust",
        "Arh" ~ "Arhelleren",
        "Fau" ~ "Fauske",
        "Hog" ~ "Hogsete",
        "Ovs" ~ "Ovstedalen",
        "Vik" ~ "Vikesland",
        "Ves" ~ "Veskre"
      ),
      blockID = substr(plotID, 1, 4),
      treatment = substr(plotID, 5, 7),
      year = "2022"
    ) |>
    select(year, siteID, blockID, treatment, plotID, C, N, CN_ratio) |>
    pivot_longer(
      cols = c(C, N, CN_ratio),
      names_to = "name",
      values_to = "value"
    ) |>
    mutate(
      unit = recode_values(
        name,
        "C" ~ "percent",
        "N" ~ "percent",
        "CN_ratio" ~ "ratio"),
      comments = recode_values(
        plotID,
        c("Fau3C",
          "Gud2G",
          "Gud2FB",
          "Gud3GB")
        ~
          "N was outside the calibration range"
      )) |>
    dataDocumentation::funcabization(convert_to = "FunCaB")
}
