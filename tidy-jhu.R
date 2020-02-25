# Covid-19 Data Clean up and Analysis
# The goal is to take the Johns Hopkins University CSSE data set and derive daily new cases

library(tidyverse)
library(lubridate)

# Get the data from JHU CSSE Github account

covid19 <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")


# Tidy the dataset 

covid19 <- covid19 %>% 
        
        # Fix blank Province/State field 
        mutate(`Province/State` = ifelse(is.na(`Province/State`), `Country/Region`, `Province/State`)) %>% 
        
        # Tidy step #1; treat date and time as a value and not a variable
        # First, specify the date columns using an inelegant method 
        # Use gather() to pivot the columns into two columns
        gather(names(covid19)[5:ncol(covid19)], key = "date_time", value = "total_cases") %>% 
        
        # If nothing happened (NA) on a particular day, remove the record
        filter(complete.cases(.)) %>% 
        
        # Convert the date_time field from a string to a POSIX date
        mutate(date_time = mdy(date_time, tz = "America/New_York"))

# Derive the new daily cases from the cumulative sum data presented this will get more specific 
# data for Provinces and makes it easy to drill down into cases in China

covid19_newcases <- covid19 %>% 
        
        # Group by Province/State because it's easy 
        group_by(`Province/State`) %>% 
        
        # Subtract the previous entry for the present entry which results in the new cases between
        # the two time periods
        mutate(new_cases = total_cases - lag(total_cases, default = first(total_cases), order_by = date_time)) 

# To look at data just by country, create a new tibble

covid19_country_newcases <- covid19 %>% 
        
        # Create a grouping to summarize results
        group_by(`Country/Region`, date_time) %>% 
        
        #Summarize them
        summarise(total_country_cases = sum(total_cases)) %>% 
        # 
        # Subtract the previous entry for the present entry which results in the new cases between
        # the two time periods
        mutate(new_cases = total_country_cases - lag(total_country_cases, default = first(total_country_cases), 
                                                     order_by = date_time)) 
