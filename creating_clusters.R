
# Script to take insurance policies data 
# and create clusters on customers and cars

# TO DO
# Create scatter plot, claim amount vs model reliability (% likelihood to claim)
# use scatter to work out cluster for cars s
# describe cluster, types of car, age, etc.

# Load libraries
library(dplyr)
library(car)
library(lubridate)

# Load data
insurance_policies_df <- read.csv('data/Insurance Policies.csv') #, stringsAsFactors = F)

# Creating new columns

# converting to YYYY-MM-DD dates
insurance_policies_df$birthdate_ymd <- as_date(insurance_policies_df$birthdate, format = "%m/%d/%Y")
insurance_policies_df$customer_age <- (Sys.Date() - insurance_policies_df$birthdate_ymd)/365.25
insurance_policies_df$car_age <- year(Sys.Date()) - insurance_policies_df$car_year

redish_colours <- c("Orange","Pink","Yellow","Crimson","Goldenrod","Red","Fuscia","Mauv")
insurance_policies_df$car_color_broad <- ifelse(insurance_policies_df$car_color %in% redish_colours,'Red spectrum','Blue spectrum')

insurance_policies_df$claimed <- ifelse(insurance_policies_df$claim_freq>0,TRUE,FALSE)

insurance_policies_df$claim_amt_number <- as.numeric(substr(insurance_policies_df$claim_amt,2,nchar(insurance_policies_df$claim_amt)))
insurance_policies_df$household_income_number <- as.numeric(substr(insurance_policies_df$household_income,2,nchar(insurance_policies_df$household_income)))

insurance_policies_df$avg_claim_amount <- ifelse(insurance_policies_df$claim_freq==0,0,insurance_policies_df$claim_amt_number/insurance_policies_df$claim_freq)

insurance_policies_df$car_kids_driving <- ifelse(insurance_policies_df$kids_driving>0,TRUE,FALSE)

x <- insurance_policies_df$car_age
insurance_policies_df$car_age_band <- case_when(
  x <= 10 ~ "0-10",
  x <= 20 ~ "11-20",
  x > 20 ~ "20+",
  TRUE ~ as.character(x)
)

# Splitting datasets
customer_df <- insurance_policies_df %>% select("ID","claimed","avg_claim_amount","customer_age","marital_status","gender","parent","education","household_income_number")
car_df <- insurance_policies_df %>% select("ID","claimed","avg_claim_amount","car_age_band","car_use","car_make","car_model","car_color_broad","coverage_zone","car_kids_driving")

car_df$claimed_val <- ifelse(car_df$claimed==TRUE,1,0)
car_meta <- unique(car_df %>% select(!c("ID","claimed","avg_claim_amount")))
car_meta$car_id <- 1:nrow(car_meta)

car_df2 <- car_df %>% inner_join(car_meta)

car_plot <- car_df2 %>% 
  select(car_id,claimed_val,avg_claim_amount) %>%
  group_by(car_id) %>%
  summarise(claimed = sum(claimed_val), claim_amount = mean(avg_claim_amount)) 


### Testing clustering
# https://towardsdatascience.com/hierarchical-clustering-on-categorical-data-in-r-a27e578f2995
str(insurance_policies_df)

library(cluster) 

gower.dist <- daisy(insurance_policies_df[ ,c(3:11)], metric = c("gower"))



