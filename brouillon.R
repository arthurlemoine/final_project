## Libraries

library(dplyr)
library(tidyr)
library(here)
library(vroom)
library(lubridate)
library(ggplot2)
library(stringr)

## LOAD DATA

here::i_am('final_project.Rproj')

pc2msoa <- vroom(here("data", "postcode_to_area.csv"))
income <- vroom(here("data", "income_2011_2019.csv"))
pop_2011 <- vroom(here("data", "population2011.csv"))
df <- vroom(here("data", "pp-complete.csv"), col_names = FALSE)

df <- df |>
  rename("unique_id" = 1,
         "price_paid" = 2,
         "deed_date" = 3,
         "postcode" = 4,
         "property_type" = 5,
         "new_build" = 6,
         "estate_type" = 7,
         "saon" = 8,
         "paon" = 9,
         "street" = 10,
         "locality" = 11,
         "town" = 12,
         "district" = 13,
         "county" = 14,
         "transaction_category" = 15,
         "linked_data_uri" = 16)

## test

rd_df <- sample_n(df, 10000)

rd_df <- rd_df |> 
  mutate(deed_date = lubridate::ymd(deed_date))

rd_df <- rd_df |> 
  mutate(year = format(deed_date, format="%Y"), 
         month = format(deed_date, format="%m"))

rd_df_sum <- rd_df |>
  group_by(year) |>
  summarise('nb_transac' = n(), 
            'mean_price' = mean(price_paid))

ggplot(rd_df_sum, aes(x = year, y = nb_transac)) + 
  geom_point()

ggplot(rd_df_sum, aes(x = year, y = mean_price)) + 
  geom_point()

## REMOVE COL

rd_df <- sample_n(df, 10000)

write.csv(rd_df, "rd_df.csv", row.names=TRUE)

pc2msoa <- pc2msoa |>
  select(pcds, msoa11cd, msoa11nm, ladnm)

df <- df |>
  select(-unique_id, -transaction_category, -linked_data_uri) 

df <- df |> 
  mutate(deed_date = lubridate::ymd(deed_date))

df <- df |> 
  mutate(year = format(deed_date, format="%Y"), 
         month = format(deed_date, format="%m"))

df_sum <- df |>
  group_by(year) |>
  summarise('nb_transac' = n(), 
            'mean_price' = mean(price_paid))

ggplot(df_sum, aes(x = year, y = nb_transac)) + 
  geom_point()

ggplot(df_sum, aes(x = year, y = mean_price)) + 
  geom_point()

## Merge and clean pollution data

pollution_2020 <- vroom(here("data", "pollution_2020.csv"))
pollution_2021 <- vroom(here("data", "pollution_2021.csv"))
pollution_2022 <- vroom(here("data", "pollution_2022.csv"))

pollution_df <- bind_rows(pollution_2020, pollution_2021, pollution_2022)
pollution_df <- select(pollution_df,c("objectid","name","unique_code","pollutant_metric","maximum_value"))
pollution_df <- pollution_df %>%
  mutate(pollutant_metric = str_replace_all(pollutant_metric, "PM10 annual mean Limit Value 2020","2020")) %>%
  mutate(pollutant_metric = str_replace_all(pollutant_metric, "PM10 annual mean Limit Value 2021","2021")) %>%
  mutate(pollutant_metric = str_replace_all(pollutant_metric, "PM10 annual mean Limit Value 2022","2022"))

pollution_df <- pollution_df %>%
  rename("year"="pollutant_metric")

write.csv(pollution_df, "pollution_df.csv", row.names=TRUE)






