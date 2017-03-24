library(rgeos)

dfTemp <- read.csv('landscapes_wkt.csv', stringsAsFactors=F)

for (i in seq(nrow(dfTemp))) {
  if (i == 1) {
    spTemp = readWKT(dfTemp$st_astext[i], row.names(dfTemp)[i])
    # If the PROJ4 string has been set, use the following instead
    # spTemp = readWKT(dfTemp$wkt_geometry[i], dfTemp$gid[i], p4s)
  }
  else {
    spTemp = rbind(
      spTemp, readWKT(dfTemp$st_astext[i], row.names(dfTemp)[i])
      # If the PROJ4 string has been set, use the following instead
      # spTemp, readWKT(dfTemp$wkt_geometry[i], dfTemp$gid[i], p4s)
    )
  }
}


sp <- SpatialPolygonsDataFrame(spTemp, dfTemp)
