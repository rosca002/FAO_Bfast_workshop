# Installation and loading of required R packages ####

if (!require(devtools)){ # install only if not installed
  install.packages("devtools", repos="http://cran.rstudio.com/")
  library(devtools)
}
if (!require(stringr)){ # install only if not installed
  install.packages("stringr", repos="http://cran.rstudio.com/")
  library(stringr)
}
if (!require(bfastSpatial)){ # install only if not installed
  install_github("loicdtx/bfastSpatial")
  library(bfastSpatial)
}

# Downloading the data ####
workshop_folder <- "~/wur_bfast_workshop" 
if(!file.exists(file.path(workshop_folder,"data.zip"))){
  download.file("https://www.dropbox.com/sh/299x5vdroyaqqs1/AAC73-EIRslzrw2B5xEpw1eza/data?dl=1",
                file.path(workshop_folder,"data.zip"),"auto",mode="wb")
  unzip(file.path(workshop_folder,"data.zip"),exdir=file.path(workshop_folder,"data"))
}

# Loading the input data for analysis ####
ndmiStack <- brick(file.path(workshop_folder,"data/Peru_ndmi_stack.grd"))
ndmiStack
ndviStack <- brick(file.path(workshop_folder,"data/Peru_ndvi_stack.grd"))
ndviStack

# Creating an output directory ####
results_directory <- file.path(workshop_folder,"data/Bfast_results")
if (!dir.exists(results_directory)){
  dir.create(results_directory)
}