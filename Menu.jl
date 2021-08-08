"""
Function that provides the user with recommended locations. 
Suggests locations that start with the same letter as the user input.
Eventually I want to implement a Neural Network for suggestions. 
"""
function suggestor(location::String, buildingDict::Dict{String, Building})
    println("The location ", location, " does not exist")
    println("Here are some recommendations")

    for (key, value) in buildingDict
        if(uppercase(key[1]) == uppercase(location[1]))
            println(key)
        end
    end
end


"""
Menu function 
"""
function menu(buildingDict::Dict{String, Building})
    println("Select an option")
    println("1) Shortest Path")
    println("2) Agent Simulation")
    println("Q) Quit\n")
    # Priming read
    userInput = readline()

    while(userInput != "1" && userInput != "2" && userInput != "Q")
        println("Select an option")
        println("1) Shortest Path")
        println("2) Agent Simulation")
        println("Q) Quit\n")
        userInput = readline()
    end

    if(userInput == "1")
        println("1) Random location")
        println("2) Pick locations")
        userInput = readline()
        if(userInput == "1")
            # Random Simulation
            println("Random simulation")
        else
            print("Starting location name: ")
            startingLocation = readline()
            try
                buildingDict[startingLocation]
            catch e
                suggestor(startingLocation, buildingDict)
            end

            print("Ending location name: ")
            endingLocation = readline()
            try
                buildingDict[endingLocation]
            catch e
                suggestor(endingLocation, buildingDict)
            end

            # Shortest route function call
        end
    elseif(userInput == "2")
        println("Agent simulation")
    else
        return
    end
end