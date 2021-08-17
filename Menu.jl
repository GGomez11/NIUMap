"""
Converts an LLA cordinate to an ENU. Does this by converting an LLA cordinate to 
an ECEF cordinate and then converting to an ENU cordinate with the use of. 

map.bounds gives the bounds of the map in LLA cordinates.
"""
function convertLLAtoENU(startLLA::Tuple{String,String}, endLLA::Tuple{String,String})::Tuple{ENU,ENU}
    ecefStart = ECEF(LLA(parse(Float64, (startLLA[1])), parse(Float64, (startLLA[2]))))
    enuStart = ENU(ecefStart, OpenStreetMapX.center(map.bounds))

    ecefEnd = ECEF(LLA(parse(Float64, endLLA[1]), parse(Float64, endLLA[2])))
    enuEnd = ENU(ecefEnd, OpenStreetMapX.center(nmap.bounds))
    return (enuStart, enuEnd)
end


"""
Menu function 
"""
function menu(buildingDict::Dict{String,Building}, p::Plots.Plot{Plots.GRBackend},  model::ABM{<:OpenStreetMapSpace})
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
            
            plotShortestRoute(startLLA, endLLA, p, model) 
            initialiseCar(startLLA, endLLA, model)
            
            for in in 0:60
                p
                frame(anim)
            end

            finishNode = point_to_nodes((parse(Float64, endLLA[1]), parse(Float64, endLLA[2])), model.space.m)
            
            for i in 0:210
                step!(model, agent_step!, 1)
                plotCar(model)
                frame(anim)


                longitudeError = osm_latlon(model.agents[1], model)[1] - latlon(model.space.m, model.space.m.v[finishNode])[1] 
                lattitudeError = osm_latlon(model.agents[1], model)[2] - latlon(model.space.m, model.space.m.v[finishNode])[2]
                
                if abs(longitudeError) < 1.0e-13 && abs(lattitudeError) < 1.0e-13
                    break 
                end
            end
            
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

            plotShortestRoute(startLLA, endLLA, p, model)
            initialiseCar(startLLA, endLLA, model)
            
            finishNode = point_to_nodes((parse(Float64, endLLA[1]), parse(Float64, endLLA[2])), model.space.m)

            for i in 0:210
                step!(model, agent_step!, 1)
                plotCar(model)
                frame(anim)


                longitudeError = osm_latlon(model.agents[1],model)[1] - latlon(model.space.m, model.space.m.v[finishNode])[1] 
                lattitudeError = osm_latlon(model.agents[1],model)[2] - latlon(model.space.m, model.space.m.v[finishNode])[2]
                
                if abs(longitudeError) < 1.0e-13 && abs(lattitudeError) < 1.0e-13
                    break 
                end
            end
        end
    elseif (userInput == "2")
        println("Agent simulation")
    else
        return
    end
end

