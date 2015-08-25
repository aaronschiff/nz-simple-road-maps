# Setup
library(maptools)

# Load data
roads = readShapeLines("data/nz-mainland-road-centrelines-topo-150k")

# Set up graphics parameters and output file
mapXRange = roads@bbox["x", "max"] - roads@bbox["x", "min"]
mapYRange = roads@bbox["y", "max"] - roads@bbox["y", "min"]
aspect = mapYRange / mapXRange
mapWidth = 1000         # Width of each individual map in pixels
numMapsPerRow = 3       # Number of maps to plot in a row
numRows = 2              # Number of rows of maps
mapHeight = round(aspect * mapWidth)
roadWidth = 0.8
png("nz-roads.png", width = numMapsPerRow * mapWidth, height = numRows * mapHeight)
par(mfrow = c(numRows, numMapsPerRow), mar = c(0, 0, 0, 0), bg = "#f8f8f8", family = "Fira Sans")

# Parameters for labels
labelOffset = 0.05    # Ratio to x and y range
labelSize = 6

# Sealed roads
plot(0, 0, type = "n", axes = FALSE, xlim = roads@bbox["x", ], ylim = roads@bbox["y", ], xlab = NA, ylab = NA)
lines(subset(roads, roads@data$surface == "sealed"), col = "black", lwd = roadWidth)
text(roads@bbox["x", "min"] + labelOffset * mapXRange, roads@bbox["y", "max"] - labelOffset * mapYRange, "Sealed", adj = c(0, 0), cex = labelSize) 

# Metalled roads
plot(mapWidth, 0, type = "n", axes = FALSE, xlim = roads@bbox["x", ], ylim = roads@bbox["y", ], xlab = NA, ylab = NA)
lines(subset(roads, roads@data$surface == "metalled"), col = "black", lwd = roadWidth)
text(roads@bbox["x", "min"] + labelOffset * mapXRange, roads@bbox["y", "max"] - labelOffset * mapYRange, "Metalled", adj = c(0, 0), cex = labelSize)

# Unmetalled roads
plot(2 * mapWidth, 0, type = "n", axes = FALSE, xlim = roads@bbox["x", ], ylim = roads@bbox["y", ], xlab = NA, ylab = NA)
lines(subset(roads, roads@data$surface == "unmetalled"), col = "black", lwd = roadWidth)
text(roads@bbox["x", "min"] + labelOffset * mapXRange, roads@bbox["y", "max"] - labelOffset * mapYRange, "Unmetalled", adj = c(0, 0), cex = labelSize)

# State highways
plot(0, mapHeight, type = "n", axes = FALSE, xlim = roads@bbox["x", ], ylim = roads@bbox["y", ], xlab = NA, ylab = NA)
lines(subset(roads, !is.na(roads@data$hway_num)), col = "black", lwd = roadWidth)
text(roads@bbox["x", "min"] + labelOffset * mapXRange, roads@bbox["y", "max"] - labelOffset * mapYRange, "State highways", adj = c(0, 0), cex = labelSize)

# One-lane roads
plot(mapWidth, mapHeight, type = "n", axes = FALSE, xlim = roads@bbox["x", ], ylim = roads@bbox["y", ], xlab = NA, ylab = NA)
lines(subset(roads, roads@data$lane_count == 1), col = "black", lwd = roadWidth)
text(roads@bbox["x", "min"] + labelOffset * mapXRange, roads@bbox["y", "max"] - labelOffset * mapYRange, "One lane", adj = c(0, 0), cex = labelSize)

# More than two lane roads
plot(2 * mapWidth, mapHeight, type = "n", axes = FALSE, xlim = roads@bbox["x", ], ylim = roads@bbox["y", ], xlab = NA, ylab = NA)
lines(subset(roads, roads@data$lane_count > 2), col = "black", lwd = roadWidth)
text(roads@bbox["x", "min"] + labelOffset * mapXRange, roads@bbox["y", "max"] - labelOffset * mapYRange, "More than two lanes", adj = c(0, 0), cex = labelSize)

# Write file
dev.off()
