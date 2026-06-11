# import packages in interactive sessions
if (interactive()) {
  suppressMessages(require(devtools))
  suppressMessages(require(usethis))
  suppressMessages(require(pak))
  suppressMessages(require(conflicted))
  suppressMessages(require(datapasta))

  options(
    warnPartialMatchArgs = TRUE,
    warnPartialMatchDollar = TRUE,
    warnPartialMatchAttr = TRUE,
    useFancyQuotes = FALSE,
    setWidthOnResize = TRUE,
    repos = c(
      CRAN = "https://packagemanager.posit.co/cran/latest",
      MV = "https://community.r-multiverse.org",
      STAN = "https://stan-dev.r-universe.dev",
      MM = "https://milesmcbain.r-universe.dev",
      DT = "https://rdatatable.r-universe.dev"
    ),
    scipen = 999,
    tigris_use_cache = TRUE
  )
}
