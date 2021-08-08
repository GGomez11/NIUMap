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

"""
Converts an LLA cordinate to an ENU. Does this by converting an LLA cordinate to 
an ECEF cordinate and then converting to an ENU cordinate with the use of. 

niuRoadNetwork.bounds gives the bounds of the map in LLA cordinates.
"""
function convertLLAtoENU(lla::LLA)::ENU
    ecef = ECEF(lla)
    enu = ENU(ecef, OpenStreetMapX.center(niuRoadNetwork.bounds))
    return enu
end
csBuildingENU = convertLLAtoENU(csBuildingLLA)    
nearest_node(niuRoadNetwork, csBuildingENU)

# Create a Dictionary that will map a node to a Node with meta data about it
# Julia interpretes keys and values by looking at the call. 
nodeDict = Dict("1" => Node())

buildingDict = Dict("1" => Building())

# Calling function that will return a Dict of Node objects
createNodeDict(nodeDict, niuPath)
createBuildingDict(buildingDict, nodeDict, niuPath)

menu(buildingDict)


# function suggestor(location::String)
#     println("The location ", location, " does not exist")
# end

# user = ""


# println("Enter a number 1 or 2")
# user = readline()
# while(user != "1" && user  != "2" )
#     println("Enter a number 1 or 2")
#     global user = readline()
# end
# user = "East Heating Plant"

# try
#     buildingDict[user]    
# catch e
#     suggestor(user)
# end


# println("fdsafdsafds")