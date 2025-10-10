# Automated Data Collection 1


# Load Libs ---------------------------------------------------------------
pacman::p_load(tidyverse, # tidyverse pkgs including purrr
               purrr, # automating 
               rvest, # parsing HTML
               janitor, # clean
               robotstxt) #checking path is permitted 


# Parse UCL wikipedia -----------------------------------------------------


url = "https://en.wikipedia.org/wiki/University_College_London"

parsed = read_html(url) # this will be a xml object

pageHeader = html_element(parsed, css="#firstHeading > span")
pageHeader_text = html_text(pageHeader) # get main header as text
print(pageHeader_text) # now print this


# Play w tables
mainTable = html_element(parsed, css="#mw-content-text > div.mw-content-ltr.mw-parser-output > table.infobox.vcard")
mainTable_df = html_table(mainTable)
head(mainTable_df)


# Tidy data ---------------------------------------------------------------
mainTable_df = mainTable_df %>% janitor::clean_names()

# Empty rows
empty_rows = apply(mainTable_df, 1, FUN=function(x) all(is.na(x) | x == ""))
mainTable_df = mainTable_df[which(!empty_rows), ]

# Exclude empty columns 
mainTable_df = mainTable_df[, -3:-7] # not relevant here
head(mainTable_df)


# Trying to automate across several links ---------------------------------

#see whether path is allowed to be scraped 
paths_allowed(paths="https://en.wikipedia.org/wiki/University_College_London")

#creating url list for the websites to be scraped 
url_list <- c(
  "https://en.wikipedia.org/wiki/University_College_London",
  "https://en.wikipedia.org/wiki/University_of_Cambridge",
  "https://en.wikipedia.org/wiki/University_of_Oxford"
)

# making function

get_table_from_wiki = function(url) {
  download.file(url, destfile="scraped_page.html", quiet=TRUE)
  
  target = read_html("scraped_page.html")
  
  table = target %>%
    html_nodes(css="#mw-content-text > div.mw-content-ltr.mw-parser-output > table.infobox.vcard") %>%
    html_table()
  
  return(table)
}


# automating with function ------------------------------------------------
map(url_list, get_table_from_wiki, .progress=TRUE) # bosh



