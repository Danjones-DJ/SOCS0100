library(RSelenium); library(rvest)
# Dynamic pages normally take 3 stages to scrape
## Where dynamic pages are ones where custom content is shown per user depending on their own inputs.


# The 3 Steps 
## Created the desired instance/steps on the dynamic page with RSelenium
#### use rselenium as a digital browser we can program
## Get the source code into R
#### RSelenium for xml, rvest for html
## Extract info needed from the source code w/ Rvest


# R Selenium --------------------------------------------------------------
## Turns R into a browser to simulate behaviour -> scrape dyanmic pages
## Originally developed for web testing -> automates browsing
#### Allows 1) intercating with browsers through computer 2) interacting with elements on a webpage
# stop with "driver$server$stop()"


# Setting up Selenium first time ------------------------------------------
library(RSelenium); library(rvest)
driver <- rsDriver(
  browser = "firefox",
  geckover = "latest",        # let it fetch a recent geckodriver
  phantomver = NULL,          # CRITICAL: do not check/download PhantomJS
  check = FALSE,              # skip extra version checks that can trigger downloads
  verbose = FALSE,
  extraCapabilities = list(
    `moz:firefoxOptions` = list(
      binary = "/Applications/Firefox.app/Contents/MacOS/firefox"
      # , args = list("-headless")  # optional
    )
  )
)

remDr <- driver[["client"]]
remDr$navigate("https://github.com/Danjones-DJ/SOCS0100")
# remDr$open("https://github.com/Danjones-DJ/SOCS0100")


remDr$getTitle()
remDr$getCurrentUrl()

# I want to open week 7 folder
# Find the "Week 7" link and click it
week7_button <- remDr$findElement(using = "link text", value = "Week 7")
week7_button$clickElement()





remDr$getActiveElement()
remDr$close()
driver[["server"]]$stop()


