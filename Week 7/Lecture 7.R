library(tidyverse); library(rvest); library(plotly)

yahoo_indices_url = "https://finance.yahoo.com/world-indices/"
yahoo_parsed = read_html(yahoo_indices_url)

yahoo_index_table_xpath = '//*[@id="main-content-wrapper"]/section[1]/div/div/div/table'

main_table = html_element(yahoo_parsed, xpath=yahoo_index_table_xpath)
main_table_df = html_table(main_table) %>% janitor::clean_names()
# View(main_table_df)


# clean price -------------------------------------------------------------
main_table_clean = main_table_df %>%
  mutate(
    price = str_remove_all(price, ","),
    price = str_extract(price, "^[0-9]+\\.?[0-9]*") %>% as.numeric()
  ) %>%
  select("name", "price", "change_percent")
#View(main_table_clean)

yahoo_data = main_table_clean 

# Plotly ---

yahoo_graph = plot_ly(
  data = yahoo_data,
  x = ~name,
  y = ~change_percent, 
  name = "Yahooooo",
  type = "bar"
  
)

yahoo_graph

# Save the plot as an HTML file
htmlwidgets::saveWidget(yahoo_graph, "yahoo_graph.html")
