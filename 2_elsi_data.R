# load packages
library(tidyverse)
library(readxl)

# import data
district_elsi_2014 <- read_excel(path = "data/ELSI-data/2014_county_ELSI_excel_export.xlsx", sheet = 1, skip = 6) |> 
  janitor::clean_names() |> 
  select(
    leaid = agency_id_nces_assigned_district_latest_available_year,
    salary_per_pupil = total_current_expenditures_salary_z32_per_pupil_v33_district_finance_2013_14
  ) |> 
  mutate(salary_per_pupil = as.numeric(salary_per_pupil))


read_excel(path = "data/ELSI-data/2020_county_ELSI_excel_export.xlsx", sheet = 1, skip = 6)
read_excel(path = "data/ELSI-data/2014_state_ELSI_excel_export.xlsx", sheet = 1, skip = 6)
read_excel(path = "data/ELSI-data/2020_state_ELSI_excel_export.xlsx", sheet = 1, skip = 6)


lea_cwift <- read_delim("data/teacher-wage-index-data/EDGE_ACS_CWIFT2021/EDGE_ACS_CWIFT2021_LEA2122.txt") |> 
  janitor::clean_names()

lea_salary_pp <- lea_cwift |> 
  left_join(district_elsi_2014) |> 
  mutate(
    adj_spp_est = salary_per_pupil / lea_cwiftest,
    adj_spp_lb = salary_per_pupil / (lea_cwiftest + qnorm(0.975)*lea_cwiftse),
    adj_spp_ub = salary_per_pupil / (lea_cwiftest - qnorm(0.975)*lea_cwiftse),
  )
  
lea_salary_pp |> 
  filter(leaid %in% c("0622710", "1201500")) |> view()

lea_salary_pp |> 
  slice_sample(n = 2)

lea_salary_pp |> 
  filter(salary_per_pupil < 15000) |> 
  slice_max(salary_per_pupil, n = 10) |> 
  semi_join(
    lea_salary_pp |> 
      filter(salary_per_pupil < 15000) |> 
      slice_max(adj_spp_est, n = 10)
  )

lea_salary_pp |> 
  slice_max(adj_spp_est, n = 10)
  

lea_salary_pp |> 
  filter(leaid %in% c("4666270", "4648390"))

lea_salary_pp |> 
  ggplot(aes(adj_spp_est - salary_per_pupil)) +
  geom_boxplot() 


lea_cwift |> skimr::skim_without_charts()


state_cwift <- read_delim("data/teacher-wage-index-data/EDGE_ACS_CWIFT2021/EDGE_ACS_CWIFT2021_State.txt")

