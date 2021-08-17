"""
Issue I have is that the package I'm using does not parse the buildings nodes. Thus, they are missing. 
I want to be able to type in a building name and start an agent near it. To do this, I plan on 
creating a data structure that contains all the older nodes and the buildings nodes. Additionally,
the data structue will also contain the details/descriptions associated with the building nodes. 
"""

# Node structure, contains a latatitude and longitude property
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

