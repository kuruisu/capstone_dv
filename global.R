options(shiny.maxRequestSize=200*1024^2)
options(scipen = 99)

library(shiny)
library(shinydashboard)
library(rgdal)
library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(tidyverse)
library(lubridate)
library(scales)
library(glue)
library(highcharter)
library(RColorBrewer)
library(DT)
library(hrbrthemes)
library(rsconnect)

# general data
airbnb <- read_csv("data_input/Airbnb_Open_Data.csv")

# Remove unwanted columns
airbnb_select <- airbnb %>% 
  select(id, `host id`, host_identity_verified,`host name`, `neighbourhood group`, 
         neighbourhood, lat, long,country,`country code`, instant_bookable, cancellation_policy, 
         `room type`, `Construction year`, price,`service fee`,`minimum nights`,`number of reviews`,
         `last review`, `review rate number`)

# Rename the columns
airbnb_select <- rename(airbnb_select, listing_id = id, 
                        host_id = `host id`,
                        host_verification_status = host_identity_verified,
                        host_name = `host name`,
                        neighbourhood_group = `neighbourhood group`,
                        country_code = `country code`,
                        instant_booking = instant_bookable,
                        room_type = `room type`,
                        construction_year = `Construction year`,
                        service_fee = `service fee`,
                        minimum_nights = `minimum nights`,
                        number_of_reviews = `number of reviews`,
                        date_last_review = `last review`,
                        rating = `review rate number`)

# Remove entries with 'NA' from columns
airbnb_select <- airbnb_select %>% 
  filter(!is.na(lat) & !is.na(long) & !is.na(instant_booking) & !is.na(construction_year)
         & !is.na(minimum_nights ) & !is.na(number_of_reviews)& !is.na(rating )
  )

# remove row have empty value
airbnb_select <- airbnb_select %>% 
  filter(!host_verification_status == "" & !host_name=="" & !neighbourhood_group=="" & !neighbourhood == ""
         & !country == "" & !country_code == "" & !price == "" & !service_fee == "" & !date_last_review== "" & !rating== "")

airbnb_select$neighbourhood_group <- gsub("brookln", "Brooklyn", airbnb_select$neighbourhood_group)

#data cleansing
airbnb_clean <- airbnb_select %>%
  mutate(price = str_replace_all(price,"([$,])", ""),
         service_fee = str_replace_all(service_fee, "([$,])", "")) %>%
  mutate(date_last_review = mdy(date_last_review),
         year_last_review = year(date_last_review)) %>% 
  mutate(price = as.double(price),
         service_fee = as.double(service_fee),
         host_verification_status = as.factor(host_verification_status),
         neighbourhood_group = as.factor(neighbourhood_group),
         neighbourhood = as.factor(neighbourhood),
         country = as.factor(country),
         country_code = as.factor(country_code),
         cancellation_policy = as.factor(cancellation_policy),
         room_type = as.factor(room_type)) %>% 
  mutate(rating_per_reviews = rating / number_of_reviews,
         price_service_percentage = (service_fee / price)*100 )

# data for display in table
airbnbframe <- airbnb_clean %>%
  select(neighbourhood, everything()) 
colnames(airbnbframe) <- gsub(pattern = "[_]", replacement = " ", colnames(airbnbframe))

#data scatter plot
scat_plot_data <- airbnb_clean %>% 
  select(neighbourhood_group, number_of_reviews, rating_per_reviews, price,room_type) %>%
  filter(room_type == "Private room") %>%
  mutate(text = paste0("Neighbourhood Group: ", neighbourhood_group,"<br>",
                       "Rating: ", number_of_reviews, "<br>",
                       "Rating Per Review: ", rating_per_reviews, "<br>",
                       "Room Price: ","$", price))




