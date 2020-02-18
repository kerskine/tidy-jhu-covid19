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
        gather(names(covid19)[5:ncol(covid19)], key = "date_time", value = "cumsum") %>% 
        
        # If nothing happened (NA) on a particular day, remove the record
        filter(complete.cases(.)) %>% 
        
        # Convert the date_time field from a string to a POSIX date
        mutate(date_time = mdy(date_time, tz = "America/New_York"))

# Derive the new daily cases from the cumulative sum data presented

covid19_newcases <- covid19 %>% 
        
        # Group by Province/State becasue it's easy 
        group_by(`Province/State`) %>% 
        
        # Subtract the previous entry for the present entry which results in the new cases between
        # the two time periods
        mutate(new_cases = cumsum - lag(cumsum, default = first(cumsum), order_by = date_time)) 

