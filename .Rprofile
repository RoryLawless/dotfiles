# import packages in interactive sessions
if (interactive()) {
  suppressMessages(require(devtools))
  suppressMessages(require(usethis))
  suppressMessages(require(pak))
  suppressMessages(require(lintr))
  suppressMessages(require(conflicted))

  # Resolve all 1Password secret references (op:// URIs) from .Renviron
  .resolve_op_secrets <- function() {
    env <- Sys.getenv()
    env <- env[startsWith(env, "op://")]
    resolved <- lapply(env, \(uri) {
      suppressWarnings(
        system(
          paste("op read", shQuote(uri)),
          intern = TRUE,
          ignore.stderr = TRUE
        )
      )
    })

    resolved <- Filter(\(x) length(x) > 0 && x != "", resolved)

    if (length(resolved) > 0) {
      do.call(Sys.setenv, resolved)
    }
  }
  .resolve_op_secrets()
  rm(.resolve_op_secrets)
}

# from https://kevinushey.github.io/blog/2015/02/02/rprofile-essentials/
# warn on partial matches
options(
  warnPartialMatchArgs = TRUE,
  warnPartialMatchDollar = TRUE,
  warnPartialMatchAttr = TRUE,
  showWarnCalls = TRUE,
  useFancyQuotes = FALSE,
  max.print = 250,
  setWidthOnResize = TRUE,
  repos = c(
    CRAN = "https://cloud.r-project.org/",
    RMULTIVERSE = "https://community.r-multiverse.org"
  ),
  scipen = 999,
  tigris_use_cache = TRUE
)

# enable autocompletions for package names in
# `require()`, `library()`
# enable fuzzy auto completions
utils::rc.settings(
  ipck = TRUE,
  fuzzy = TRUE,
  backtick = TRUE
)
