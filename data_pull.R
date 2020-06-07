covidnp_url <- "https://data.nepalcorona.info/api/v1/covid/summary"
covidnp_data <- jsonlite::fromJSON(covidnp_url, flatten=TRUE)

library(dplyr)

total_cases <- covidnp_data$total
cases <- covidnp_data$province$cases 
recovered <- covidnp_data$province$recovered
deaths <- covidnp_data$province$deaths

province_status <- cases %>% merge(recovered, by = "province", sort = T) %>% 
  merge(deaths, by = "province", sort = T, all = T)

province_status[is.na(province_status)] <- 0


names(province_status) <- c("province", "cases", "recovered", "deaths")




library(tidyr)

province_status <- province_status %>% pivot_longer(cols = 2:4, 
                                 names_to = "type", 
                                 values_to = "count")

d_cases <- covidnp_data$district$cases
d_recovered <- covidnp_data$district$recovered
d_deaths <- covidnp_data$district$recovered

district_status <- d_cases %>% merge(d_recovered, by = "district", sort = T, all = T) %>% 
  merge(d_deaths, by = "district", sort = T, all = T)

names(district_status) <- c("D_ID", "cases", "recovered", "deaths")

district_status[is.na(district_status)] <- 0

district_data <- jsonlite::fromJSON("district_nepal.json", flatten=TRUE)

district_data$n <- NULL

district_status <- district_status %>% pivot_longer(cols = 2:4, 
                                                    names_to = "type", 
                                                    values_to = "count")



district_status <- district_status %>% merge(district_data, by = "D_ID", sort = T, all = T)


https://data.nepalcorona.info/api/v1/covid/timeline



readr::write_csv(province_status, "province_status.csv")
readr::write_csv(district_status, "district_status.csv")
