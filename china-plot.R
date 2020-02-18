covid19_newcases %>% 
        filter(`Country/Region` == "Mainland China") %>% 
        ggplot(aes(x = date_time, y = new_cases)) + geom_line() + 
        facet_wrap(`Province/State` ~ ., scales = "free") +
        labs(title = "New Covid-19 Cases in China by Province", 
             subtitle = "Source: Johns Hopkins Univ. CSSE", 
             caption = "https://github.com/kerskine/tidy-jhu-covid19") +
        xlab("Date") + ylab("Number of New Cases") 