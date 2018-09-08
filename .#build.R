#!/usr/local/bin/Rscript
require(devtools)
devtools::document('R')
devtools::check(".", args = c("--no-examples", "--no-tests"))
#devtools::check(".")
devtools::install(".")


