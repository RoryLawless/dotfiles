# enable devtools in interactive sessions
if (interactive()) {
	suppressMessages(require(devtools))
	suppressMessages(require(pak))
	suppressMessages(require(lintr))
}

# from https://kevinushey.github.io/blog/2015/02/02/rprofile-essentials/
# warn on partial matches
options(
	warnPartialMatchAttr = TRUE,
	warnPartialMatchDollar = TRUE,
	warnPartialMatchArgs = TRUE,
	# fancy quotes are annoying and lead to
	# 'copy + paste' bugs / frustrations
	useFancyQuotes = FALSE,
	# print only 250 elements by default
	max.print = 250,
	setWidthOnResize = TRUE,
	repos = c(
		CRAN = "https://packagemanager.posit.co/cran/latest",
		cmdstanr = "https://stan-dev.r-universe.dev",
		typstcv = "https://kazuyanagimoto.r-universe.dev"
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
