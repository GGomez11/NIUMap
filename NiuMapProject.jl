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
Converts an LLA cordinate to an ENU. Does this by firstly converting to 
an ECEF cordinate and then convertin to an ENU cordinate with the use of. 

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

# Calling function that will return a Dict of Node objects
createNode(nodeDict, niuPath)

# nodeId = ""
# for word in eachline("niuMap.osm")
    
#     # Check for <node> element. 
#     if(occursin("<node id", word))
#         # Makes an array of the indeces which are quotes in the variable word
#         findQuotes = findall("\"", word)

#         firstDigit = findfirst(r"[0-9]", word)
#         endQuote = findall("\"", word)

#         nodeId = word[findQuotes[1].start+1:findQuotes[2].start-1]
        
#         latStart = findfirst("lat", word)
#         nodeLat = word[latStart.start+5:latStart.start+14]
        
#         # Add 1 to account for the negative sign
#         lonStart = findfirst("lon", word)
#         nodeLon = word[lonStart.start+7:lonStart.start+15]

#         nodeDict[nodeId] = Node(nodeLat, nodeLon, "N/A", "N/A", "N/A")
#     end

#     if(occursin("<nd ref", word))
#         findQuotes = findall("\"", word)
#         # Remember previous word
#         firstDigit = findfirst(r"[0-9]", word)
#         endQuote = findall("\"", word)

#         nodeId = word[findQuotes[1].start+1:findQuotes[2].start-1]
        
#     end

#     # Sets the alternative name such as "Dusable" -> "Statistics Department"
#     if(occursin("alt_name", word))
#         findQuotes = findall("\"", word)
#         altName = word[findQuotes[3].start+1:findQuotes[4].start-1]
#         nodeDict[nodeId].altName = altName
#     end 

#     if(occursin("description", word))
#         findQuotes = findall("\"", word)
#         description = word[findQuotes[3].start+1:findQuotes[4].start-1]
#         nodeDict[nodeId].description = description
#     end 
#     #println(word)
#     if(occursin("<tag k=\"name\"",word))
#         findQuotes = findall("\"", word)
#         name = word[findQuotes[3].start+1:findQuotes[4].start-1]
#         nodeDict[nodeId].name = name
#         nodeDict[name] = nodeDict[nodeId]
#         #nodeDict[nodeId] = Node()
#     end
# end

