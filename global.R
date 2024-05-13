library(dplyr)

# Portal metadata
app_title = "Ocean Impact Monitoring of Floating Offshore Wind Developments in California"
app_description = "This app offers an interactive way to visualize the breadth of long-term ocean monitoring that is relavent to measuring the impacts of floating offshore wind developments in California."
attribution_string = ""
provided_crs = ""

# Center coordinate of map
initial_long = -118.42
initial_lat = 33.59

# Read in project data
datasets <- read_csv(here("data", "dataset_rows.csv"))
variable_types <- read_csv(here("data", "variable_types.csv"))

# What variables are available to filter on?
variable_list <- variable_types$variable

# What organizations are available to filter on?
organization_list <- unique(datasets$organization)
