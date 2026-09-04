# ~/.Rprofile

# Applies to every session, including Rscript and background installs
options(
  repos = c(
    CRAN = "https://packagemanager.posit.co/cran/latest",
    STAN = "https://stan-dev.r-universe.dev",
    MM   = "https://milesmcbain.r-universe.dev"
  ),
  tigris_use_cache = TRUE,
  Ncpus = max(1L, parallel::detectCores() - 1L)
)

if (interactive()) {
  options(
    warnPartialMatchArgs   = TRUE,
    warnPartialMatchDollar = TRUE,
    warnPartialMatchAttr   = TRUE,
    useFancyQuotes   = FALSE,
    setWidthOnResize = TRUE,
    scipen = 999,
    usethis.protocol = "ssh",
    usethis.description = list(
      "Authors@R" = utils::person(
        "Rory", "Lawless",
        email = "rory@rorylawless.com",
        role  = c("aut", "cre")
      )
    )
  )

  # Attach dev tools when installed; skips quietly in renv projects that lack them
  local({
    pkgs <- c("devtools", "usethis", "pak", "conflicted")
    installed <- vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)
    for (pkg in pkgs[installed]) {
      suppressPackageStartupMessages(library(pkg, character.only = TRUE))
    }
  })
}
