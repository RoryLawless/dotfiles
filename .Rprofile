# import packages in interactive sessions
if (interactive()) {
	suppressMessages(require(devtools))
	suppressMessages(require(usethis))
	suppressMessages(require(pak))
	suppressMessages(require(lintr))
	suppressMessages(require(conflicted))
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
		CRAN = "https://packagemanager.posit.co/cran/latest",
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
