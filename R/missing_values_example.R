library(dplyr)
library(tmap)
library(purrr)
library(rcartocolor)
library(belg)
library(raster)

sample_rasters_path = dir("data/sample_rasters", pattern = ".tif$", full.names = TRUE)
sample_rasters = lapply(sample_rasters_path, raster)

be_na = sapply(sample_rasters, get_boltzmann, na_adjust = FALSE) 
be_na

be_na_adj = sapply(sample_rasters, get_boltzmann, na_adjust = TRUE)
be_na_adj

sample_rasters_na = sample_rasters[order(be_na)]
sample_rasters_na_adj = sample_rasters[order(be_na_adj)]

be_na_ordered = be_na[order(be_na)]
be_na_adj_ordered = be_na_adj[order(be_na_adj)]

my_plot = function(x, ent){
  tm_shape(x) +
    tm_raster(style = "cont", 
              breaks = c(-7.45, 863.79, 1735.03),
              title = "Elevation \n(m asl)",
              palette = carto_pal(n = 7, name = "Temps"),
              midpoint = NA,
              legend.show = FALSE) +
    tm_layout(main.title = round(ent, 0),
              main.title.size = 1,
              main.title.position = "center",
              frame = FALSE)
}

# not adjusted for missing values
tmap_arrange(map2(sample_rasters_na,
                  be_na_ordered,
                  my_plot), 
             nrow = 1)

# adjusted for missing values
tmap_arrange(map2(sample_rasters_na_adj,
                  be_na_adj_ordered, 
                  my_plot), 
             nrow = 1)
