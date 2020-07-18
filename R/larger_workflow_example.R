library(dplyr)
library(tmap)
library(rcartocolor)
library(belg)
library(raster)
library(sf)

svn_dem = raster("data/svn_dem.tif")

svn_grid_geom = st_as_sfc(st_bbox(svn_dem))
svn_grid = st_make_grid(svn_grid_geom, cellsize = 5760)
svn_grid = st_sf(id = seq_along(svn_grid),
                 geom = svn_grid)

tm_slo_dem = tm_shape(svn_dem) +
  tm_raster(style = "cont", 
            breaks = c(-100, 1000, 2000, 3000),
            labels = c("-100", "1000", "2000", "3000"),
            title = "Elevation \n(m asl)",
            palette = carto_pal(n = 7, name = "Temps"),
            midpoint = NA) +
  tm_shape(svn_grid, is.master = TRUE) +
  tm_borders(col = "black", lwd = 0.2) +
  tm_layout(legend.outside = TRUE,
            frame = FALSE)

tm_slo_dem

# it takes a few minutes
svn_grid$results = NA
for (i in seq_len(nrow(svn_grid))){
  small_raster = crop(svn_dem, svn_grid[i, ])
  if(!all(is.na(getValues(small_raster)))){
    svn_grid$results[i] = get_boltzmann(small_raster)
  } 
}
head(svn_grid)

tm_slo_bol = tm_shape(svn_grid) +
  tm_polygons("results", 
              style = "cont",
              palette = rev(carto_pal(n = 7, name = "Earth")),
              title = "Boltzmann \nentropy \n(aggregation-based \nmethod)",
              midpoint = mean(svn_grid$results),
              contrast = c(0, 1),
              colorNA = "#f5f5f5",
              lwd = 0.5
  ) +
  tm_layout(legend.outside = TRUE,
            frame = FALSE)
tm_slo_bol
