# NiuMap

* Program that visualizes a shortest path on the Northern Illinois campus
* Program creates a gif with an agent traversing the path. 
* Users are allowed to pick locations or random locations found on the campus. 

## Package Installation
```julia
using Pkg; Pkg.add("OpenStreetMapXPlot", "OpenStreetMapX", "Plots", "LightGraphs", "Agents")
```

## Gif Created
![Shortest Path GIF](NIUShortestPath.gif)