
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


