"""
    Developer: Gregory Gomez
    Project: NIU Map

    Objective: To visualize the optimal paths on the NIU campus. Uses the Plots.gr() backend to achieve this.  

"""
# using Base: Float16
using OpenStreetMapXPlot
using OpenStreetMapX
using Plots
using LightGraphs
using Agents
include("Node.jl")
include("Building.jl")
include("Car.jl")
include("Menu.jl")
include("Plotting.jl")
include("Suggestor.jl")

# Path to the .osm file
niuPath = "./niuMap.osm"

# Creating Agent Base Model 
niuModel = ABM(Car, OpenStreetMapSpace(niuPath))

# Creating a Dictionary that will hold all the node elements and their 
# latitudes and longitudes
nodeDict = Dict("1" => Node())

# Creating a Dictionary that will map the names of buildings to
# metadata about the building. 
buildingDict = Dict("1" => Building())

# Creating dictionaries 
createNodeDict(nodeDict, niuPath)
createBuildingDict(buildingDict, nodeDict, niuPath)

# Creating an Animation
anim = Animation()

# Creating initial Plot
p = OpenStreetMapXPlot.plotmap(niuModel.space.m, width=1000, height=800)

# Displaying program
menu(buildingDict, p, niuModel)

# Display end plot 
p

# Create gif 
gif(anim, "astar.gif", fps = 30)



