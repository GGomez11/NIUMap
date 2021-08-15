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



# Path to the .osm file
niuPath = "./niuMap.osm"

# Parses the osm file and creates the road network based on the map data. 
#niuRoadNetwork = OpenStreetMapX.get_map_data(niuPath, use_cache=false, trim_to_connected_graph=true)


csBuildingLLA = LLA(41.9435221, -88.7720755)

# OSM space 
niuModel = ABM(Car, OpenStreetMapSpace(niuPath))

# csBuildingENU = convertLLAtoENU(csBuildingLLA)    
# nearest_node(niuRoadNetwork, csBuildingENU)

# Create a Dictionary that will map a node to a Node with meta data about it
# Julia interpretes keys and values by looking at the call. 
nodeDict = Dict("1" => Node())

buildingDict = Dict("1" => Building())

# Calling function that will return a Dict of Node objects
createNodeDict(nodeDict, niuPath)
createBuildingDict(buildingDict, nodeDict, niuPath)


p = OpenStreetMapXPlot.plotmap(niuModel.space.m, width=1000, height=800)

menu(buildingDict, p, niuModel)
p
# location = "Fdsafdsafds"


