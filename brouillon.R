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
  rename("year"="pollutant_metric", "msoa"="unique_code")

pollution_df <- pollution_df %>%
  group_by(msoa) %>%
  summarize(mean(maximum_value))

write.csv(pollution_df, "pollution_df.csv", row.names=TRUE)

income1112 <- vroom(here("data", "income1112.csv"), skip = 5, col_names = FALSE)
income1314 <- vroom(here("data", "income1314.csv"), skip =5, col_names = FALSE)
income1516 <- vroom(here("data", "income1516.csv"), skip = 5, col_names = FALSE, col_select = -c(11:14))
income1718 <- vroom(here("data", "income1718.csv"), skip = 5, col_names = FALSE)
income1920 <- vroom(here("data", "income1920.csv"), skip = 5, col_names = FALSE, delim = ";")

income1112[,c(7:10)] <- income1112[,c(7:10)]*52
income1314[,c(7:10)] <- income1314[,c(7:10)]*52
income1920 <- income1920 %>%
  mutate(X7 = str_replace_all(X7," ","")) %>%
  mutate(X8 = str_replace_all(X8," ","")) %>%
  mutate(X9 = str_replace_all(X9," ","")) %>%
  mutate(X10 = str_replace_all(X10," ",""))

income1920$X7 <- as.numeric(income1920$X7)
income1920$X8 <- as.numeric(income1920$X8)
income1920$X9 <- as.numeric(income1920$X9)
income1920$X10 <- as.numeric(income1920$X10)

income1112 <- income1112 %>%
  mutate(X11 = 2012)

income1314 <- income1314 %>%
  mutate(X11 = 2014)

income1516 <- income1516 %>%
  mutate(X11 = 2016)

income1718 <- income1718 %>%
  mutate(X11 = 2018)

income1920 <- income1920 %>%
  mutate(X11 = 2020)

income_df <- bind_rows(income1112, income1314, income1516, income1718, income1920)

variable_names <- c("msoa","MSOA_name","local_authority_code","local_authority_name","region_code","region_name","total_annual_income","upper_confidence_limit","lower_confidence_limit","confidence_interval","year")

colnames(income_df) <- variable_names

income_df_odd <- income_df %>%
  mutate(year = year - 1)

income_df <- bind_rows(income_df, income_df_odd)

income_df <- income_df |>
  select(msoa, MSOA_name, region_name, total_annual_income, confidence_interval, year)

write.csv(income_df, "income_df.csv", row.names=TRUE)

## Matching postocode to area

postcode_df <- pc2msoa %>%
  select(pcds, msoa21cd, ladnm) %>%
  rename("postcode" = "pcds","msoa" = "msoa21cd", "region_name" = "ladnm" )

## Matching all the datasets with the main data

final_df <- vroom(here("rd_df.csv"))

final_df <- final_df |>
  select(-1,-unique_id, -linked_data_uri) 

final_df <- final_df %>%
  left_join(postcode_df, by = "postcode")

final_df <- final_df %>%
  left_join(income_df, by = c("msoa","year"))

population_df <- vroom(here("data", "population2011.csv"), skip = 1, col_names = FALSE)

population_df <- population_df %>%
  select(-3,-4) %>%
  rename("postcode" = "X1", "population" = "X2", "households" = "X5")

final_df <- final_df %>%
  left_join(population_df, by = "postcode")


