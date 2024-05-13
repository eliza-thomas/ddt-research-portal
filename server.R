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
  
  context_geometry = read_sf(here("data", "context_geometry")) %>% st_transform(provided_crs)

    ## Interactive Map ##
    # Create a Leaflet map
    output$map <- renderLeaflet({
      leaflet() %>%
        # Adding World_Ocean base maps
        addTiles(urlTemplate = "https://server.arcgisonline.com/ArcGIS/rest/services/Ocean/World_Ocean_Base/MapServer/tile/{z}/{y}/{x}", options = tileOptions(minZoom = 6, maxZoom = 16)) %>%
        addTiles(urlTemplate = "https://server.arcgisonline.com/ArcGIS/rest/services/Ocean/World_Ocean_Reference/MapServer/tile/{z}/{y}/{x}", options = tileOptions(minZoom = 6, maxZoom = 16)) %>% 
        # Set initial map position/zoom
        setView(lng = initial_long, lat = initial_lat, zoom = 5)
      
      # Render a static feature if provided
      if (!is_null(context_geometry)) {
        
        # leafletProxy("map") %>%
        #   addPolygons(
        #     data = context_geometry$geometry,
        #     group = "contextual",
        #     fill = FALSE,
        #     color = "yellow",
        #     weight = 4
        #   )
      }
    })
  
  # Filter map data reactively
  observe({
    if (is.null(input$variable_types) && is.null(input$organization)) {
      return()
    }
    
    # Observe a change to selected input variables
    event <- input$variable_types
    filtered_rows$vals = row_entities
    if (is.null(event)){
      filtered_rows$vals = filtered_rows$vals
    } else {
      filtered_rows$vals = row_entities %>%
        filter(variable %in% event)
    }
    
    # Observe a change to selected input variables
    event <- input$organization
    if (is.null(event)){
      filtered_rows$vals = filtered_rows$vals
    } else {
      filtered_rows$vals = row_entities$vals %>%
        filter(organization %in% event)
    }
    
    # leafletProxy("map") %>% clearPopups() %>% clearGroup(group = "datasets_filtered") %>% 
    #   addPolygons(
    #     data = context_geom, 
    #     group = "contextual",
    #     fill = FALSE,
    #     color = "#FF0000",
    #     weight = 4
    #   )
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
    imageHeight = 60
  )
}