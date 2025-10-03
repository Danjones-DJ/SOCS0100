library(tidyverse); library(rvest)

yahoo_indices_url = "https://finance.yahoo.com/world-indices/"
yahoo_parsed = read_html(yahoo_indices_url)

yahoo_index_table_xpath = '//*[@id="main-content-wrapper"]/section[1]/div/div/div/table'

main_table = html_element(yahoo_parsed, xpath=yahoo_index_table_xpath)
main_table_df = html_table(main_table) %>% janitor::clean_names()
View(main_table_df)
