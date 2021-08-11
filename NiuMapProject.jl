"""
    Developer: Gregory Gomez
    Project: NIU Map

    Objective: To visualize the optimal paths on the NIU campus. Uses the Plots.gr() backend to achive this.  

"""
#using Base: Float16
using OpenStreetMapXPlot
using OpenStreetMapX
using Plots
include("NodeObject.jl")
include("Menu.jl")

# Path to the .osm file
niuPath = "C:\\Users\\bobgo\\Desktop\\Development\\Julia\\NIU Map\\niuMap.osm"

# Parses the osm file and creates the road network based on the map data. 
niuRoadNetwork = OpenStreetMapX.get_map_data(niuPath, only_intersections=false, use_cache=false)

p = OpenStreetMapXPlot.plotmap(niuRoadNetwork, width=1000, height=800, km=true)

csBuildingLLA = LLA(41.9435221, -88.7720755)



#csBuildingENU = convertLLAtoENU(csBuildingLLA)    
#nearest_node(niuRoadNetwork, csBuildingENU)

# Create a Dictionary that will map a node to a Node with meta data about it
# Julia interpretes keys and values by looking at the call. 
nodeDict = Dict("1" => Node())

buildingDict = Dict("1" => Building())

# Calling function that will return a Dict of Node objects
createNodeDict(nodeDict, niuPath)
createBuildingDict(buildingDict, nodeDict, niuPath)

Tuplee = menu(buildingDict)


#location = "Fdsafdsafds"
println(Tuplee)
