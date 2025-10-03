library(RSelenium); library(rvest); library(tidyverse)


# Load Driver -------------------------------------------------------------

driver = rsDriver(
  browser = "firefox", # Choose what browser to use
  geckover = "latest", # GeckoDriver is how we bridge from Selenium to Firefox, do other browsers have their own?
  phantomver = NULL, # Phantomver is a depracated system, turn it off
  check = FALSE, # Don't check is the browser is where we say, assume true
  verbose = FALSE, # Don't spam us with logs pls
  extraCapabilities = list(
    `moz:firefoxOptions` = list(
      binary = "/Applications/Firefox.app/Contents/MacOS/firefox" # Where are youuuuu fire fox
    )
  )
)

remDr = driver[["client"]] # create remDr to remotely drive around the web!

# Choose destination! -----------------------------------------------------

remDr$navigate("https://amazon.co.uk") # Open Amazon on my firefox


# Find pop-up -------------------------------------------------------------
Sys.sleep(1)
tryCatch({
  # Try to find the popover
  popover = remDr$findElement(using = "css selector", value = ".a-popover-wrapper")
  
  # If we got here, it exists! Now click close
  close = remDr$findElement(using = "css selector", value = ".a-icon-close")
  close$clickElement()
  cat("✓ Popover closed\n")
  
}, error = function(e) {
  # Element doesn't exist, that's fine
  cat("✓ No popover to close\n")
})

# Next wait for cookies to bake
Sys.sleep(1)

# Aha!
detect_cookie = function(driver) {
  tryCatch({
    banner = driver$findElement(using="css selector", value="#cos-banner")
    cat("cos-banner detected! \n")
    return(banner)
  }, error = function(e) {
    cat("cos-banner not detected! FUCK!!!!! \n")
    return(NULL)
  })
}
banner = detect_cookie(remDr)

# Accept the cookie
accept = remDr$findElement(using="css selector", value = "span.a-declarative:nth-child(1)")
accept$clickElement()
print("cookies accepted")

# it works haha


# Making Search Function

auto_search = function(string) {
  search_box = remDr$findElement(using="css selector", value="#twotabsearchtextbox")
  search_box$sendKeysToElement(list(string))
  
  search_button = remDr$findElement(using="css selector", value="#nav-search-submit-button")
  search_button$clickElement()
  
  Sys.sleep(1)
  
  sort_dropdown = remDr$findElement(using="css selector", value="#a-autoid-0-announce")
  sort_dropdown$clickElement()
  
  Sys.sleep(1)
  
  sort_by_reviews = remDr$findElement(using="css selector", value="#s-result-sort-select_3")
  sort_by_reviews$clickElement()
  
  Sys.sleep(3)
  
  best_reviews_only = remDr$findElement(using="css selector", value="#filter-p_72 > span:nth-child(1)")
  best_reviews_only$clickElement()
  
  Sys.sleep(3)
  
  discounts_only = remDr$findElement(using="css selector", value="#filter-p_n_deal_type > span:nth-child(1)")
  discounts_only$clickElement()
  
  Sys.sleep(3)
}

auto_search("Rubber Ducky")


# Now we have a nice search feature, we want to organise and scrape -------

#product

product_one = remDr$findElement(using="css selector", value=".widgetId\\=search-results_1 > span:nth-child(1)")
name = product_one$findChildElement(using="css selector", value="h2 span")$getElementText()[[1]]

#overall rating
# Click to open popover
rating_trigger = product_one$findChildElement(using="css selector", value="span.a-declarative[data-action='a-popover'] a")
rating_trigger$clickElement()
Sys.sleep(2)  # Wait for popover to load

# Now search from remDr (the whole page), NOT from product_one
overall_rating = remDr$findElement(using="css selector", value="#acr-popover-title")$getElementText()[[1]]

#review count
total_reviews = product_one$findChildElement(using="css selector", value=".a-size-base")$getElementText()[[1]]

#price
price_whole = product_one$findChildElement(using="css selector", value=".a-price-whole")$getElementText()[[1]]
price_fraction = product_one$findChildElement(using="css selector", value=".a-price-fraction")$getElementText()[[1]]
price = paste0(price_whole, ".", price_fraction)
price = as.numeric(price)

#delivery date
delivery = product_one$findChildElement(using="css selector", value=".a-text-bold")$getElementText()[[1]]


# Output 
cat("Name:", name, "\n")
cat("price (£):", price, "\n")
cat("Overall rating:", overall_rating, "\n")
cat("total_reviews:", total_reviews, "\n")
cat("delivery by:", delivery, "\n")


# STOPPPPP ----------------------------------------------------------------
driver[["server"]]$stop()


