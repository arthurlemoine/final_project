## Libraries

library(dplyr)
library(tidyr)
library(here)
library(vroom)
library(lubridate)
library(ggplot2)

## LOAD DATA

here::i_am('final_project.Rproj')

pc2msoa <- vroom(here("data", "postcode_to_area.csv"))
income <- vroom(here("data", "income_2011_2019.csv"))
pop_2011 <- vroom(here("data", "population2011.csv"))
df <- vroom(here("data", "pp-complete.csv")) ## to implement: col_names = false + add a header vector 

## REMOVE COL

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



