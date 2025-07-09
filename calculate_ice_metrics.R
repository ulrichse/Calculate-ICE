
library(tidycensus)
library(tidyverse)

# Set options
options(tidycensus = list(geometry = FALSE))

# Set year and geography
year <- 2010
geo <- "tract"
state <- "NC"  
dataset <- "acs5"

acs_vars <- load_variables(year = year, dataset = dataset, cache = TRUE)

# All households (income)
income_all_households <- get_acs(geography = geo, 
                                 table = "B19001", 
                                 state = state, 
                                 year = year, 
                                 survey = dataset) %>%
  select(GEOID, NAME, variable, estimate) %>%
  pivot_wider(
    names_from = variable,
    values_from = estimate
  )%>%
  mutate(total_hh = B19001_001, 
         total_hh_above100k = B19001_014 + B19001_015 +B19001_016 + B19001_017, 
         total_hh_under25k = B19001_002 + B19001_003 + B19001_004 + B19001_005) %>%
  select(GEOID, NAME, starts_with("total"))

# White households (income)
income_white_households <- get_acs(geography = geo, 
                                 table = "B19001A", 
                                 state = state, 
                                 year = year, 
                                 survey = dataset) %>%
  select(GEOID, NAME, variable, estimate) %>%
  pivot_wider(
    names_from = variable,
    values_from = estimate
  )%>%
  mutate(white_hh = B19001A_001, 
         white_hh_above100k = B19001A_014 + B19001A_015 +B19001A_016 + B19001A_017) %>%
  select(GEOID, NAME, white_hh, white_hh_above100k)

# Black households (income)
income_black_households <- get_acs(geography = geo, 
                                 table = "B19001B", 
                                 state = state, 
                                 year = year, 
                                 survey = dataset) %>%
  select(GEOID, NAME, variable, estimate) %>%
  pivot_wider(
    names_from = variable,
    values_from = estimate
  )%>%
  mutate(black_hh = B19001B_001, 
         black_hh_under25k = B19001B_002 + B19001B_003 + B19001B_004 + B19001B_005) %>%
  select(GEOID, NAME, black_hh, black_hh_under25k)

# Hispanic households (income)
income_hispanic_households <- get_acs(geography = geo, 
                                   table = "B19001I", 
                                   state = state, 
                                   year = year, 
                                   survey = dataset) %>%
  select(GEOID, NAME, variable, estimate) %>%
  pivot_wider(
    names_from = variable,
    values_from = estimate
  )%>%
  mutate(hispanic_hh = B19001I_001, 
         hispanic_hh_under25k = B19001I_002 + B19001I_003 + B19001I_004 + B19001I_005) %>%
  select(GEOID, NAME, hispanic_hh, hispanic_hh_under25k)

# Population 
pop <- get_acs(geography = geo, 
                     table = "B03002", 
                     state = state, 
                     year = year, 
                     survey = dataset) %>%
  select(GEOID, NAME, variable, estimate) %>%
  pivot_wider(
    names_from = variable,
    values_from = estimate
  )%>%
  mutate(total_pop = B03002_001, 
         white_pop = B03002_003,
         black_pop = B03002_004,
         hispanic_pop = B03002_012,
         hispanic_pop_nonwhite = B03002_012 - B03002_013) %>%
  select(GEOID, NAME, total_pop, white_pop, black_pop, hispanic_pop, hispanic_pop_nonwhite)

pop <- pop %>%
  left_join(income_all_households, by = c('GEOID', 'NAME')) %>%
  left_join(income_white_households, by = c('GEOID', 'NAME')) %>%
  left_join(income_black_households, by = c('GEOID', 'NAME')) %>%
  left_join(income_hispanic_households, by = c('GEOID', 'NAME')) 

ice_metrics <- pop %>%
  mutate(ice_race_black = (white_pop - black_pop) / total_pop, 
         ice_race_hispanic = (white_pop - hispanic_pop) / total_pop,
         ice_race_hispanicnw = (white_pop - hispanic_pop_nonwhite) / total_pop,
         ice_race_blackhispanic = (white_pop - (hispanic_pop + black_pop)) / total_pop,
         ice_race_blackhipsanicnw = (white_pop - (hispanic_pop_nonwhite + black_pop)) / total_pop,
         ice_income = (total_hh_above100k - total_hh_under25k) / total_hh,
         ice_income_white_black = (white_hh_above100k - black_hh_under25k) / total_hh,
         ice_income_white_hispanic = (white_hh_above100k - hispanic_hh_under25k) / total_hh,
         ice_income_white_black_hispanic = (white_hh_above100k - (black_hh_under25k + hispanic_hh_under25k)) / total_hh
  ) %>%
  select(GEOID, NAME, starts_with("ice"))

summary(ice_metrics) # Make sure all ICE scores are between -1 and 1
         
# Write off file
write.csv()
         
         
         
         
