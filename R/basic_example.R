library(belg)
library(raster)
library(tmap)
land_gradient1 = raster(system.file("raster/land_gradient1.tif", package = "belg"))
land_gradient2 = raster(system.file("raster/land_gradient2.tif", package = "belg"))
belg_data = brick(land_gradient1, land_gradient2)
names(belg_data) = c("land_gradient1", "land_gradient2")

tm_shape(belg_data) +
  tm_raster(style = "cont", title = "Values:")

get_boltzmann(land_gradient1)
get_boltzmann(land_gradient2)
