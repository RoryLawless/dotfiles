
function updateR -d "Updates R packages using devtools::update_packages and rig to run the code"
	# Helper function to easily update R packages outside of the IDE
	rig run -e "remotes::update_packages(upgrade = 'always', build = TRUE, repos = c(CRAN = 'https://packagemanager.posit.co/cran/latest', cmdstanr = 'https://stan-dev.r-universe.dev', typstcv = 'https://kazuyanagimoto.r-universe.dev'))"
end
