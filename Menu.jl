"""
Function that prints locations that beging with the same letter as the 
user inputted location. Eventually I want to implement a Neural Network for suggestions. 

Returns Y or N based on if the user wants to try to submit a location again. 
"""
function locationSuggestor(location::String, buildingDict::Dict{String,Building})
    userInput = ""
    println("The location ", location, " does not exist")
    println("Here are some recommendations")

    # Print locations that start with the same letter as the user input
    for (key, value) in buildingDict
        if (uppercase(key[1]) == uppercase(location[1]))
            println(key)
        end
    end

    println("Would you like to try again?")
    println("Y) Yes")
    println("N) No")
    
    userInput = readline()

    # Loop until Y or N is passed in by user
    while (uppercase(userInput) != "Y" && uppercase(userInput) != "N")
        println("Would you like to try again?")
        println("Y) Yes")
        println("N) No")
        userInput = readline()
    end
    return uppercase(userInput)
end

"""
Adds a route to the map. Gets nodes closes to the lattitude and longitude passed in. 
"""
function plotShortestRoute(startLLA::Tuple{String, String}, endLLA::Tuple{String, String}, p::Plots.Plot{Plots.GRBackend}, n)
    # Path to the .osm file
    niuPath = "./niuMap.osm"

    # Parses the osm file and creates the road network based on the map data. 
    #niuRoadNetwork = get_map_data(niuPath, only_intersections=false, use_cache=false)

    pointA = point_to_nodes((parse(Float64, startLLA[1]), parse(Float64, startLLA[2])), niuRoadNetwork)
    pointB = point_to_nodes((parse(Float64, endLLA[1]), parse(Float64, endLLA[2])), niuRoadNetwork)

    shortestRoute = shortest_route(niuRoadNetwork, pointA, pointB)[1]
    
    addroute!(p, n, shortestRoute; route_color="red")
end

"""
Converts an LLA cordinate to an ENU. Does this by converting an LLA cordinate to 
an ECEF cordinate and then converting to an ENU cordinate with the use of. 

niuRoadNetwork.bounds gives the bounds of the map in LLA cordinates.
"""
function convertLLAtoENU(startLLA::Tuple{String,String}, endLLA::Tuple{String,String})::Tuple{ENU,ENU}
    ecefStart = ECEF(LLA(parse(Float64, (startLLA[1])), parse(Float64, (startLLA[2]))))
    enuStart = ENU(ecefStart, OpenStreetMapX.center(niuRoadNetwork.bounds))

    ecefEnd = ECEF(LLA(parse(Float64, endLLA[1]), parse(Float64, endLLA[2])))
    enuEnd = ENU(ecefEnd, OpenStreetMapX.center(niuRoadNetwork.bounds))
    return (enuStart, enuEnd)
end


"""
Menu function 
"""
function menu(buildingDict::Dict{String,Building}, p::Plots.Plot{Plots.GRBackend}, n)
    println("Select an option")
    println("1) Shortest Path")
    println("2) Agent Simulation")
    println("Q) Quit\n")
    
    # Priming read
    userInput = readline()

    # Input validation. Loops while user does not input a 1, 2 or Q
    while (userInput != "1" && userInput != "2" && userInput != "Q")
        println("Select an option")
        println("1) Shortest Path")
        println("2) Agent Simulation")
        println("Q) Quit\n")
        userInput = readline()
    end

    # Shortest path simulation
    if (userInput == "1")
        println("1) Random locations")
        println("2) Pick locations\n")
        userInput = readline()
        
        # Input validation. Loops while user does not input a 1, 2 or Q
        while (userInput != "1" && userInput != "2")
            println("1) Random locations")
            println("2) Pick locations")
            userInput = readline()
        end

        # Random locations
        if (userInput == "1")
            println("Random simulation")
            randNum = rand(1:length(buildingDict))
            # Get all keys of the buildingDict. 
            # Create an array holding those keys. 
            # Find random index of an array. 
            startingLocation = collect(keys(buildingDict))[randNum]
            
            randNum = rand(1:length(buildingDict))
            endingLocation = collect(keys(buildingDict))[randNum]

            # Tuple containing the the start/end locations Latitude and longitude. 
            startLLA = (buildingDict[startingLocation].lat, buildingDict[startingLocation].lon)
            endLLA = (buildingDict[endingLocation].lat, buildingDict[endingLocation].lon)

            #enuTuple = convertLLAtoENU(startLLA, endLLA)
            println(startLLA)
            println(endLLA)
            plotShortestRoute(startLLA, endLLA, p, n) 
            
        else
            startingLocation = ""
            endingLocation = ""

            # Loop until user inputs a location that exists
            while (true)
                print("Starting location name: ")
                startingLocation = readline()
                
                try
                    # Key error if startingLocation is not a key in buildingDict
                    buildingDict[startingLocation]
                    break
                catch e
                    if (locationSuggestor(startingLocation, buildingDict) == "N")
                        return
                    end
                    continue
                end
            end
            
            # Loop until user inputs a location that exists
            while (true)
                print("Ending location name: ")
                endingLocation = readline()
               
                try
                    # Key error if startingLocation is not a key in buildingDict
                    buildingDict[endingLocation]
                    break
                catch e
                    if (locationSuggestor(endingLocation, buildingDict) == "N")
                        return
                    end
                    continue
                end
            end

            # Tuple containing the the start/end locations Latitude and longitude. 
            startLLA = (buildingDict[startingLocation].lat, buildingDict[startingLocation].lon)
            endLLA = (buildingDict[endingLocation].lat, buildingDict[endingLocation].lon)

            #enuTuple = convertLLAtoENU(startLLA, endLLA)

            plotShortestRoute(startLLA, endLLA, p, n)
            
        end
    elseif (userInput == "2")
        println("Agent simulation")
    else
        return
    end
end

