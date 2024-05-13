library(tidyverse)
library(sf)
library(here)

# Portal metadata
app_title = "Ocean Impact Monitoring of Floating Offshore Wind Developments in California"
app_description = "This app offers an interactive way to visualize the breadth of long-term ocean monitoring that is relavent to measuring the impacts of floating offshore wind developments in California."
attribution_string = "Sources: Esri, spatial data sources available upon request"
provided_crs <- st_crs(4326)

#context_geometry_filename = "LeaseAreas_poly.kmz"

# Center coordinate of map
initial_long = -120.78
initial_lat = 35.56

# Read in project data
datasets <- read_csv(here("data", "dataset_rows.csv"))
variable_types <- read_csv(here("data", "variable_types.csv"))

# What variables are available to filter on?
variable_list <- variable_types$variable

# What organizations are available to filter on?
organization_list <- unique(datasets$organization)
