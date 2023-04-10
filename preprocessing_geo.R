# Script for pre-processing data

set.seed(42)
wgs84 <- st_crs(4326)

# Read data
sampling = read_csv(here("data", "DDT_Sampling_Efforts.csv")) %>% clean_names() %>% rowwise() %>% mutate(id = uuid::UUIDgenerate())
dumpsites <- read_sf(here("data", "Disposal_Sites_14_SCCWRP_1973", "Disposal_Sites_14_SCCWRP_1973.shp")) %>% mutate(site_label = paste0("Dumpsite #", Site_Numbe)) %>% st_transform(wgs84)

# PI Specific points, not provided in base sheet.
# valentine = read_csv(here("data", "unprocessed", "valentine-1.csv")) %>% st_as_sf(coords = c("X","Y"), crs = wgs84)
# jensen = read_csv(here("data", "unprocessed", "jensen-1.csv")) %>% st_as_sf(coords = c("Longitude_ddeg","Latitude_ddeg"), crs = wgs84)
# rouse = read_csv(here("data", "unprocessed", "rouse-1.csv")) %>% st_as_sf(coords = c("Longitude_ddeg","Latitude_ddeg"), crs = wgs84)
# semmens_rec = read_csv(here("data", "unprocessed", "semmens-1.csv")) %>% st_as_sf(coords = c("Long_DD","Lat_DD"), crs = wgs84)
# semmens_meso = read_csv(here("data", "unprocessed", "semmens-2.csv")) %>% clean_names() %>% st_as_sf(coords = c("lon_dec","lat_dec"), crs = wgs84)

# TESTING SAMPLING INFO DISPLAY
coord_list = list()
id_list = c()
chull_list = c()
centroid_list = c()

for (i in c(1:nrow(sampling))) {
  
  sample = sampling[i,]
  id = sample$id
  
  # get list of points for row
  if (sample$sample_type == "Points") {
    coords = sample$sampling_area_points_geometry
    if (!is.na(coords)) {
      # parse coordinates into point df
      coords = coords %>% str_split(pattern = "(?<=\\))(,\\s*)(?=\\()")
      coords = coords[[1]] %>% str_replace_all("[//(//)]", "") %>% str_split(", ", simplify = T)
      coords = as.data.frame(coords) %>% st_as_sf(coords = c("V2","V1"), crs = wgs84)
      
      # Add label/detail to points
      #coords = coords %>% mutate()
      
      centroid = coords %>% st_combine() %>% st_centroid()
      hull = coords %>% st_combine() %>% st_convex_hull()
      coord_list[[id]] = list(centroid = centroid, geo = coords, chull = hull)
    }
  } else if (sample$sample_type == "file") {
    file = sample$sampling_area_points_geometry
    point_df = read_csv(here("data", "unprocessed", file)) %>% clean_names() %>% st_as_sf(coords = c("lon_dec","lat_dec"), crs = wgs84)
    
    coord_list[[id]] = list(
      centroid = point_df %>% st_combine() %>% st_centroid(),
      geo = point_df,
      chull = point_df %>% st_combine() %>% st_convex_hull()
    )
  } 
}


