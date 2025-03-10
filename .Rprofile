# enable devtools in interactive sessions
if (interactive()) {
  suppressMessages(require(devtools))

  # from https://kevinushey.github.io/blog/2015/02/02/rprofile-essentials/
  # warn on partial matches
  options(
    warnPartialMatchAttr = TRUE,
    warnPartialMatchDollar = TRUE,
    warnPartialMatchArgs = TRUE
  )

  # enable autocompletions for package names in
  # `require()`, `library()`
  # enable fuzzy auto completions
  utils::rc.settings(
    ipck = TRUE,
    fuzzy = TRUE
  )

  # fancy quotes are annoying and lead to
  # 'copy + paste' bugs / frustrations
  options(useFancyQuotes = FALSE)

  # print only 250 elements by default
  options(max.print = 250)

  options(setWidthOnResize = TRUE)

  options(
    repos = c(
      P3M = "https://packagemanager.posit.co/cran/latest",
      # CRAN = "https://cloud.r-project.org",
      rpolars = "https://rpolars.r-universe.dev",
      cmdstanr = "https://stan-dev.r-universe.dev",
      httr2 = "https://r-lib.r-universe.dev/",
      typstcv = "https://kazuyanagimoto.r-universe.dev"
    )
  )

  options(scipen = 999)

  options(tigris_use_cache = TRUE)
}
