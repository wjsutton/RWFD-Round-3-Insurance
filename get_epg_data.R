# Get Car data 
# https://www.fueleconomy.gov/feg/download.shtml

library(downloader)
library(rvest)
library(dplyr)
library(stringr)

url <- 'https://www.fueleconomy.gov/feg/download.shtml'
page <- read_html(url)
all_links <- page %>% html_nodes("a") %>% html_attr('href')
all_links <- data.frame(link=all_links,stringsAsFactors = F)
zip_links <- filter(all_links,grepl(".*zip$", link))
# found /feg/epadata/vehicles.csv.zip which is all the vehicle data

data_zip_url <- "https://www.fueleconomy.gov/feg/epadata/vehicles.csv.zip"
download(data_zip_url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "data")

