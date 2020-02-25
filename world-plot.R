covid19_country_newcases %>% 
        ggplot(aes(x = date_time, y = new_cases)) + geom_line() + 
        facet_wrap(`Country/Region` ~ ., scales = "free") +
        labs(title = "New Global Covid-19 Cases by Country", 
             subtitle = "Source: Johns Hopkins Univ. CSSE", 
             caption = "https://github.com/kerskine/tidy-jhu-covid19") +
        xlab("Date") + ylab("Number of New Cases") 