
library("rgdal")
library(raster)
library(adehabitatHR)

pts <- read.csv("D:/AGGES R-SPATIAL_ANALYSIS/hotspot_analysis/data.csv")
pts_df <- SpatialPointsDataFrame(pts[,1:2], pts, proj4string = CRS("+init=epsg:21037"))
# plot(pts_df)

juja <- readOGR(dsn = "D:/AGGES R-SPATIAL_ANALYSIS/hotspot_analysis/juja", layer = "juja_utm")

Extent <- extent(juja) #this is the geographic extent of the grid.
#Here we specify the size of each grid cell in metres (since those are the units our data are projected in).
resolution <- 100
x <- seq(Extent[1],Extent[2],by=resolution)  # where resolution is the pixel size you desire
y <- seq(Extent[3],Extent[4],by=resolution)
xy <- expand.grid(x=x, y=y)
coordinates(xy) <- ~x+y
gridded(xy) = TRUE
# plot(xy)

all <- raster(kernelUD(pts_df, h = "href", grid = xy))
# plot(juja, border="red", add=T)
rr <- mask(all, juja)

library(RColorBrewer)
png("hotspotMap.png",width = 750,height = 500)
plot(rr, main = "Hotspot map", col=rev(brewer.pal(n=10, name="RdBu")), legend.args = list(text = 'Gi*'));plot(juja, add=TRUE)
plot(pts_df, pch = 20,cex = 0.5, add=T)

library(GISTools)
north.arrow(297000,9885700, 500,lab = "N",col='black')
scalebar(5000, type='bar', divs=2, lonlat = FALSE, below = "meters")
dev.off()
