"""
Contain buildings with their corresponding lon lat and name. 
"""
mutable struct Building
    lat::String
    lon::String
    name::String
    altName::String
    description::String
end

Building() = Building("N/A", "N/A", "N/A", "N/A", "N/A")

"""
Issue I have is that the package I'm using does not parse the buildings nodes. Thus, they are missing. 
I want to be able to type in a building name and start an agent near it. To do this, I plan on 
creating a data structure that contains all the older nodes and the buildings nodes. Additionally,
the data structue will also contain the details/descriptions associated with the building nodes. 
"""

# Node that contains lon lat 
mutable struct Node
    lat::String
    lon::String
end

# Zero argument constructor (Outer constructor method)
Node() = Node("N/A", "N/A")

"""
Create a dictionary of nodes 
"""
function createNodeDict(nodeDict::Dict{String, Node}, file::String)
    for word in eachline(file)
        if(occursin("<node id", word))
            findQuotes = findall("\"", word)

            nodeId = word[findQuotes[1].start+1:findQuotes[2].start-1]
            
            latStart = findfirst("lat", word)
            nodeLat = word[latStart.start+5:latStart.start+14]
            
            # Add 1 to account for the negative sign
            lonStart = findfirst("lon", word)
            nodeLon = word[lonStart.start+5:lonStart.start+15]

            nodeDict[nodeId] = Node(nodeLat, nodeLon)
        end
    end
    return nodeDict
end

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
        
        if(firstCaseFlag && occursin("<tag k=\"building\"", word))
            building = true 
        end
        
        if(occursin("<tag k=\"name\"", word) && firstCaseFlag && building)
            findQuotes = findall("\"", word)

            buildingName = word[findQuotes[3].start+1:findQuotes[4].start-1]
            println(buildingName)
            
            buildingDict[buildingName] = Building(lat, lon, "N/A", "N/A", "N/A")

            firstCaseFlag = false
            building = false
            lat = ""
            lon = ""
        end

        # Second case
        if(occursin("<nd ref", word))
            findQuotes = findall("\"", word)
            # Remember previous word
            firstDigit = findfirst(r"[0-9]", word)
            endQuote = findall("\"", word)

            nodeId = word[findQuotes[1].start+1:findQuotes[2].start-1]
            
        end

        # Sets the alternative name, such as "Dusable" -> "Statistics Department"
        if(occursin("alt_name", word))
            findQuotes = findall("\"", word)
            altName = word[findQuotes[3].start+1:findQuotes[4].start-1]
            if(haskey(nodeDict, nodeId))
                #nodeDict[nodeId].altName = altName
            end
        end 

        if(occursin("description", word))
            findQuotes = findall("\"", word)
            description = word[findQuotes[3].start+1:findQuotes[4].start-1]
            #nodeDict[nodeId].description = description
        end 

        if(occursin("<tag k=\"name\"",word))
            findQuotes = findall("\"", word)
            name = word[findQuotes[3].start+1:findQuotes[4].start-1]
            
            # Creating a new entry but with the node name as as a key.
            if(haskey(nodeDict, nodeId))

                #nodeDict[nodeId].name = name
                #nodeDict[name] = nodeDict[nodeId]
                # Removing the old entry with the nodeid as the key. 
                #println("Deleting ", nodeId)
                #delete!(nodeDict, nodeId)
            end
        end
    end
    return buildingDict
end