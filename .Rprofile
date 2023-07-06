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
  # enable fuzzy autocompletions
  utils::rc.settings(ipck = TRUE,
                     fuzzy = TRUE)

  # warnings are errors
  options(warn = 2)

  # fancy quotes are annoying and lead to
  # 'copy + paste' bugs / frustrations
  options(useFancyQuotes = FALSE)

  # print only 250 elements by default
  options(max.print = 250)

  options(setWidthOnResize = TRUE)

  options(repos = c(CRAN = "https://packagemanager.posit.co/cran/latest"))

  options(prompt = "r$> ")

  options(scipen = 999)

}
