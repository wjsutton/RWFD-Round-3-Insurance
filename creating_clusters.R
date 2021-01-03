
# Script to take insurance policies data 
# and create clusters on customers and cars

# TO DO
# Check for cars dataset
# work out cluster for cars more likely to have a claim
# describe cluster, types of car, age, etc.

# Load libraries
library(dplyr)
library(car)
library(lubridate)

# Load data
insurance_policies_df <- read.csv('data/Insurance Policies.csv', stringsAsFactors = F)

# Creating new columns

# converting to YYYY-MM-DD dates
insurance_policies_df$birthdate_ymd <- as_date(insurance_policies_df$birthdate, format = "%m/%d/%Y")
insurance_policies_df$customer_age <- (Sys.Date() - insurance_policies_df$birthdate_ymd)/365.25
insurance_policies_df$car_age <- year(Sys.Date()) - insurance_policies_df$car_year

insurance_policies_df$claimed <- ifelse(insurance_policies_df$claim_freq>0,TRUE,FALSE)

insurance_policies_df$claim_amt_number <- as.numeric(substr(insurance_policies_df$claim_amt,2,nchar(insurance_policies_df$claim_amt)))
insurance_policies_df$household_income_number <- as.numeric(substr(insurance_policies_df$household_income,2,nchar(insurance_policies_df$household_income)))

insurance_policies_df$avg_claim_amount <- ifelse(insurance_policies_df$claim_freq==0,0,insurance_policies_df$claim_amt_number/insurance_policies_df$claim_freq)

insurance_policies_df$car_kids_driving <- ifelse(insurance_policies_df$kids_driving>0,TRUE,FALSE)

# testing area
test <- head(insurance_policies_df,20)
as_date(test$birthdate, format = "%m/%d/%Y")
age <- (Sys.Date() - as_date(test$birthdate, format = "%m/%d/%Y"))/365.25
as.numeric(substr(test$claim_amt,2,nchar(test$claim_amt)))

# Splitting datasets
customer_df <- insurance_policies_df %>% select("ID","avg_claim_amount","customer_age","marital_status","gender","parent","education","household_income_number")
car_df <- insurance_policies_df %>% select("ID","avg_claim_amount","car_age","car_use","car_make","car_model","car_color","coverage_zone","car_kids_driving")

#lm.fit <- lm(avg_claim_amount ~ car_age, data = car_df)
#lm.fit2 <- lm(avg_claim_amount ~.-ID, data = car_df)

#library(corrplot)
#corrplot(cor(car_df %>% select(-ID)), type="upper", method="ellipse", tl.cex=0.9)

#library(cluster)
#library(dplyr)
#library(ggplot2)
#library(readr)
#library(Rtsne)

#gower_dist <- daisy(car_df, metric = "gower")
#gower_mat <- as.matrix(gower_dist)
