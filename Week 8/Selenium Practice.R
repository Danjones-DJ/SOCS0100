library(RSelenium); library(rvest)


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
  
  Sys.sleep(3)
  
  sort_dropdown = remDr$findElement(using="css selector", value="#a-autoid-0-announce")
  sort_dropdown$clickElement()
  
  Sys.sleep(3)
  
  sort_by_reviews = remDr$findElement(using="css selector", value="#s-result-sort-select_3")
  sort_by_reviews$clickElement()
  
  Sys.sleep(3)
  
  best_reviews_only = remDr$findElement(using="css selector", value="#filter-p_72 > span:nth-child(1)")
  best_reviews_only$clickElement()
  
  Sys.sleep(3)
  
  discounts_only = remDr$findElement(using="css selector", value="#filter-p_n_deal_type > span:nth-child(1)")
  discounts_only$clickElement()
  
}

auto_search("Ball Gag")

# STOPPPPP ----------------------------------------------------------------
driver[["server"]]$stop()


