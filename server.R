library(leaflet)
library(tidyverse)
library(shinyalert)
library(tidyverse)
library(janitor)
library(sf)
library(tidyverse)
library(here)
source('global.R')

function(input, output, session) {
  
  # Read shapefiles for each org
  row_entities = datasets
  filtered_rows = reactiveValues(vals = row_entities)
  
  context_geometry = read_sf(here("data", "context_geometry")) %>% st_transform(st_crs(4326)) %>% st_zm()
  context_geometry = st_sfc(context_geometry$geometry) 

  # Read each of the shapefiles in via their encompassing Organization folder
  organization_geometry_map = list()
  for (folder in list.dirs(here("data","dataset_geometry/"), full.names = FALSE, recursive = FALSE)) {
    geometry = read_sf(here("data", "dataset_geometry", folder)) %>% st_transform(st_crs(4326)) %>% st_zm()
    organization_geometry_map[[folder]] = geometry
  }
  
  organization_geometries = bind_rows(organization_geometry_map, .id = "organization") %>% select(organization,geometry)

  ## Interactive Map ##
  # Create a Leaflet map
  output$map <- renderLeaflet({
    leaflet() %>%
      # Adding World_Ocean base maps
      addTiles(urlTemplate = "https://server.arcgisonline.com/ArcGIS/rest/services/Ocean/World_Ocean_Base/MapServer/tile/{z}/{y}/{x}", options = tileOptions(minZoom = 3, maxZoom = 16)) %>%
      addTiles(urlTemplate = "https://server.arcgisonline.com/ArcGIS/rest/services/Ocean/World_Ocean_Reference/MapServer/tile/{z}/{y}/{x}", options = tileOptions(minZoom = 3, maxZoom = 16)) %>%  
      # Set initial map position/zoom
      setView(lng = initial_long, lat = initial_lat, zoom = 8) %>% 
      # Add/style contextual shapefile
      addPolygons(
        data = context_geometry,
        fillOpacity  = 1,
        stroke = TRUE,
        color = "#000",
        fillColor = "#fff3b0",
        opacity = 1,
        weight = 2
      ) %>%
      # Add/style dataset shapefiles
      addPolygons(
        group = "datasets_filtered",
        data = organization_geometries,
        fillOpacity  = 0.1,
        stroke = TRUE,
        color = "#fff",
        fillColor = "#d41",
        opacity = 1,
        weight = 2,
        
      )
  })
  
  # Filter map data reactively
  observeEvent(list(input$variable_types, input$organizations), {
    if (is.null(input$variable_types) && is.null(input$organizations)) {
      leafletProxy("map") %>% clearGroup(group = "datasets_filtered") %>% clearPopups()
      return()
    }
    
    # Observe and store any change to selected variable types
    event <- input$variable_types
    filtered_rows$vals = row_entities
    if (is.null(event)){
      filtered_rows$vals = filtered_rows$vals %>% filter(F)
    } else {
      filtered_rows$vals = filtered_rows$vals %>%
        filter(variable %in% event)
    }
    
    variable_matches = unique(filtered_rows$vals)
    
    # Observe and store any change to selected organizations
    event <- input$organizations
    filtered_rows$vals = row_entities
    if (is.null(event)){
      filtered_rows$vals = filtered_rows$vals %>% filter(F)
    } else {
      filtered_rows$vals = filtered_rows$vals %>%
        filter(organization %in% event)
    }
    organization_matches = unique(filtered_rows$vals)
    
    # Subset the geometries provided to Leaflet to include matches to any filter value (OR logic)
    organization_geometries_filtered = union(organization_matches, variable_matches) %>%
      group_by(organization) %>% 
      mutate(variable_types = paste0(variable, collapse = ", ")) %>%
      distinct(organization, variable_types) %>%
      inner_join(organization_geometries) %>%
      st_as_sf(crs = provided_crs) %>%
      filter(!st_is_empty(geometry))
      
    leafletProxy("map") %>% clearGroup(group = "datasets_filtered") %>% clearPopups() %>%
      addPolygons(
        group = "datasets_filtered",
        data = organization_geometries_filtered,
        fillOpacity  = 0.1,
        stroke = TRUE,
        color = "#fff",
        fillColor = "#d41",
        opacity = 1,
        weight = 2,
        popup = paste("Organization: ", organization_geometries_filtered$organization, "<hr/>Variables: ", organization_geometries_filtered$variable_types),
      )
  })
  
  
  ## Welcome message ##############################
  shinyalert(
    html = T,
    title = app_title,
    text = app_description,
    type = "",
    size = "m",
    imageUrl = "https://s2020.s3.amazonaws.com/media/logo-scripps-ucsd-dark.png",
    imageWidth = 500,
    imageHeight = 60,
    closeOnClickOutside = TRUE
  )
}