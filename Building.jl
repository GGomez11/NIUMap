"""
Contain buildings with their corresponding lon lat and name. 
"""
mutable struct Building
    lat::String
    lon::String
    altName::String
    description::String
end

Building() = Building("N/A", "N/A", "N/A", "N/A")

"""
Funtion that creates a Dictionary of Node objects. This dictionary will 
be used to determine a lattitude and longitude of a place a user wants to begin at. 
"""
function createBuildingDict(buildingDict::Dict{String, Building}, nodeDict::Dict{String, Node}, file::String)
    nodeId = ""
    firstCaseFlag = false
    secondCaseFlag = false
    building = false
    lat = "" 
    lon = ""
    altName = ""
    latSum = 0
    lonSum = 0
    nodeCounter = 0
    buildingBool = false
    buildingName = ""
    altName = "N/A"
    description = "N/A"

    #for word in eachline("niuMap.osm")
    for word in eachline(file)
        # First case
        if(occursin("<node id", word))
            firstCaseFlag = true
            secondCaseFlag = false
            # Makes an array of the indeces which are quotes in the variable word
            findQuotes = findall("\"", word)

            firstDigit = findfirst(r"[0-9]", word)
            endQuote = findall("\"", word)

            nodeId = word[findQuotes[1].start+1:findQuotes[2].start-1]
            
            latStart = findfirst("lat", word)
            lat = word[latStart.start+5:latStart.start+14]
            
            # Add 1 to account for the negative sign
            lonStart = findfirst("lon", word)
            lon = word[lonStart.start+5:lonStart.start+15]

            #nodeDict[nodeId] = Node(lat, nodeLon, "N/A", "N/A", "N/A")
        end
        
        # Sets building flag to on. This advises that we should keep the current node 
        if(firstCaseFlag && occursin("<tag k=\"building\"", word))
            building = true 
        end
        
        # Get alt name
        if(occursin("<tag k=\"alt_name\"", word))
            findQuotes = findall("\"", word)
            altName = word[findQuotes[3].start+1:findQuotes[4].start-1]
        end

        # Get the name and uses it as a key for the lat and long of the building. 
        if(occursin("<tag k=\"name\"", word) && firstCaseFlag && building)
            findQuotes = findall("\"", word)
            buildingName = word[findQuotes[3].start+1:findQuotes[4].start-1]
            buildingDict[buildingName] = Building(lat, lon, altName, description)

            # Reseting variables for next run 
            firstCaseFlag = false
            building = false
            lat = ""
            lon = ""
            altName = "N/A"
            description = "N/A"
        end

        # Second case.
        # Way element signifies a way (ordered list of nodes)
        if(occursin("<way id", word))
            secondCaseFlag = true
        end

        # Get current nodeId
        if(occursin("<nd ref", word) && secondCaseFlag)
            findQuotes = findall("\"", word)
            secondCaseNodeId = word[findQuotes[1].start+1:findQuotes[2].start-1]
            
            # Add lat and lon of current node 
            latSum += parse(Float64, nodeDict[secondCaseNodeId].lat)
            lonSum += parse(Float64, nodeDict[secondCaseNodeId].lon)
            nodeCounter = nodeCounter + 1
        end

        # Get alt name
        if(occursin("<tag k=\"alt_name\"", word))
            findQuotes = findall("\"", word)
            altName = word[findQuotes[3].start+1:findQuotes[4].start-1]
        end

        # Determine if way is describing a building 
        if(occursin("<tag k=\"building\"", word))
            buildingBool = true 
        end

        # Get description name
        if(occursin("<tag k=\"description\"", word))
            findQuotes = findall("\"", word)
            description = word[findQuotes[3].start+1:findQuotes[4].start-1]
        end

        # Get name of building
        if(occursin("<tag k=\"name\"", word) && buildingBool)
            findQuotes = findall("\"", word)
            buildingName = word[findQuotes[3].start+1:findQuotes[4].start-1]
        end

        # Reset variables
        if(occursin("</way>", word))
            if(buildingBool)
                buildingDict[buildingName] = Building(string(latSum/nodeCounter), string(lonSum/nodeCounter), altName, description)
            end
            
            buildingBool = false 
            secondCaseFlag = false
            latSum = 0
            lonSum = 0
            nodeCounter = 0
            altName = "N/A"
            description = "N/A"
        end
    end
    return buildingDict
end