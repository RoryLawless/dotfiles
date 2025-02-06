
function updateR -d "Updates R packages using devtools::update_packages and rig to run the code"
	# Helper function to easily update R packages outside of the IDE
	rig run -e "remotes::update_packages(upgrade = 'always', build = TRUE, repos = c(P3M = 'https://packagemanager.posit.co/cran/latest', rpolars = 'https://rpolars.r-universe.dev', cmdstanr = 'https://stan-dev.r-universe.dev'))"
end
