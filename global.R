library(dplyr)

# view mode indicator
isDetailedView = FALSE

# TODO build programatically from unique(~institution/parameter) list (maybe)
# Choices for drop-downs
meas_vars <- c(
  "Benthic invertebrates" = "benthic invertebrates",
  "DDT" = "ddt",
  "DDX" = "ddx",
  "Deep biota" = "deep biota",
  "Fish: Recreational" = "recreational fish",
  "Fish: Mesopelagic" = "mesopelagic fish",
  "Genetic potential" = "genetic potential",
  "Microbe: Diversity & composition" = "microbial diversity and composition",
  "Microbe: Taxonomy" = "microbial taxonomy", 
  "PAH" = "pah",
  "Particles" = "particles",
  "PCB" = "pcb",
  "Sediment" = "sediment",
  "Sediment: Chlorophyll" = "sediment: chlorophyll",
  "Sediment: Grain size" = "sediment: grain size",
  "Sediment: Organic matter" = "sediment: organic matter",
  "Sediment: Pigments" = "sediment: pigments",
  "Sediment: Suspended" = "sediment: suspended"
)

inst_vars <- c(
  "Scripps Instituion of Oceanography" = "sio",
  "San Diego State University" = "sdsu",
  "University of California Santa Barbara" = "ucsb"
)