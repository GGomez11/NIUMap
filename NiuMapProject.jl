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

"""
Menu function 
"""
function menu()
    println("Select an option")
    println("1) Shortest Path")
    println("2) Agent Simulation\n")
    userInput = readline()

    if(userInput == "1")
        println("1) Random location")
        println("2) Pick locations")
        userInput = readline()
        if(userInput == "1")
            # Random Simulation
        else
            print("Starting location name: ")
            startingLocation = readline()
            print("Ending location name: ")
            endingLocation = readline()
            # Call function
        end
    elseif(userInput == "2")
        println("Agent simulation")
    end
end





# Create a Dictionary that will map a node to a Node with meta data about it
# Julia interpretes keys and values by looking at the call. 
nodeDict = Dict("1" => Node())

buildingDict = Dict("1" => Building())

# Calling function that will return a Dict of Node objects
createNodeDict(nodeDict, niuPath)
createBuildingDict(buildingDict, nodeDict, niuPath)

menu()