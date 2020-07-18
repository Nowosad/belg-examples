library(belg)
library(raster)
library(tmap)

belg_data = brick(land_gradient1, land_gradient2)
names(belg_data) = c("land_gradient1", "land_gradient2")

tm_shape(belg_data) +
  tm_raster(style = "cont", title = "Values:")

get_boltzmann(land_gradient1)
get_boltzmann(land_gradient2)