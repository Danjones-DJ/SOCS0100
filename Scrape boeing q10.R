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

remDr$navigate("https://investors.boeing.com/investors/reports/")


# Find pop-up -------------------------------------------------------------
Sys.sleep(2)

detect_cookie = function(driver) {
  tryCatch({
    banner = driver$findElement(using="css selector", value="div.ot-sdk-row:nth-child(1)")
    cat("Banner found! \n")
    return(banner)
  }, error = function(e) {
    cat("cos-banner not detected! FUCK!!!!! \n")
    return(NULL)
  })
}
banner = detect_cookie(remDr)

# Accept the cookie
accept = remDr$findElement(using="css selector", value = "#onetrust-accept-btn-handler")
accept$clickElement()
print("cookies accepted")



# find Q1 2025 ------------------------------------------------------------
Sys.sleep(2)
year25q1 <- remDr$findElement(
  using = "css selector",
  value = "ul.ftRow:nth-child(6) > li:nth-child(2) > a:nth-child(1)"
)
year25q1$clickElement()


# gpt  --------------------------------------------------------------------
Sys.sleep(2)
pdf_url <- remDr$getCurrentUrl()[[1]]

# download straight from the CDN
tmp_pdf <- tempfile(fileext = ".pdf")
download.file(pdf_url, tmp_pdf, mode = "wb")

txt <- pdftools::pdf_text(tmp_pdf)




# stop --------------------------------------------------------------------

driver[["server"]]$stop()
