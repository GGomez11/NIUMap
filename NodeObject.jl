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
    name::String
    altName::String
    description::String
end

# Zero argument constructor (Outer constructor method)
Node() = Node("N/A", "N/A", "N/A", "N/A", "N/A")

"""
Funtion that creates a Dictionary of Node objects. This dictionary will 
be used to determine a lattitude and longitude of a place a user wants to begin at. 
"""
function createNode(nodeDict::Dict{String, Node}, file::String)
    nodeId = ""
    #for word in eachline("niuMap.osm")
    for word in eachline(file)
        
        # Check for <node> element. 
        if(occursin("<node id", word))
            # Makes an array of the indeces which are quotes in the variable word
            findQuotes = findall("\"", word)

            firstDigit = findfirst(r"[0-9]", word)
            endQuote = findall("\"", word)

            nodeId = word[findQuotes[1].start+1:findQuotes[2].start-1]
            
            latStart = findfirst("lat", word)
            nodeLat = word[latStart.start+5:latStart.start+14]
            
            # Add 1 to account for the negative sign
            lonStart = findfirst("lon", word)
            nodeLon = word[lonStart.start+7:lonStart.start+15]

            nodeDict[nodeId] = Node(nodeLat, nodeLon, "N/A", "N/A", "N/A")
        end

        if(occursin("<nd ref", word))
            findQuotes = findall("\"", word)
            # Remember previous word
            firstDigit = findfirst(r"[0-9]", word)
            endQuote = findall("\"", word)

            nodeId = word[findQuotes[1].start+1:findQuotes[2].start-1]
            
        end

        # Sets the alternative name such as "Dusable" -> "Statistics Department"
        if(occursin("alt_name", word))
            findQuotes = findall("\"", word)
            altName = word[findQuotes[3].start+1:findQuotes[4].start-1]
            nodeDict[nodeId].altName = altName
        end 

        if(occursin("description", word))
            findQuotes = findall("\"", word)
            description = word[findQuotes[3].start+1:findQuotes[4].start-1]
            nodeDict[nodeId].description = description
        end 

        if(occursin("<tag k=\"name\"",word))
            findQuotes = findall("\"", word)
            name = word[findQuotes[3].start+1:findQuotes[4].start-1]
            nodeDict[nodeId].name = name
            nodeDict[name] = nodeDict[nodeId]
            #nodeDict[nodeId] = Node()
        end
    end
    return nodeDict
end