"""
Function that provides the user with recommended locations. 
Suggests locations that start with the same letter as the user input.
Eventually I want to implement a Neural Network for suggestions. 
"""
function suggestor(location::String, buildingDict::Dict{String, Building})
    
    
    userInput = ""
    println("The location ", location, " does not exist")
    println("Here are some recommendations")

    # Print locations that start with the same letter as the user input
    for (key, value) in buildingDict
        if(uppercase(key[1]) == uppercase(location[1]))
            println(key)
        end
    end

    println("Would you like to try again?")
    println("Y) Yes")
    println("N) No")
    
    userInput = readline()

    while(uppercase(userInput) != "Y" && uppercase(userInput) != "N")
        println("Would you like to try again?")
        println("Y) Yes")
        println("N) No")
        userInput = readline()
    end
    return userInput 
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
            randNum = rand(1:length(buildingDict))
            startingLocation = collect(keys(buildingDict))[randNum]
            
            randNum = rand(1:length(buildingDict))
            endingLocation = collect(keys(buildingDict))[randNum]

            println("Starting location:", startingLocation)
            println("Ending location:", endingLocation)
        else
            startingLocation = ""
            endingLocation = ""

            while(true)
                print("Starting location name: ")
                startingLocation = readline()
                
                try
                    buildingDict[startingLocation]
                    break
                catch e
                    suggestor(startingLocation, buildingDict)
                    continue
                end
            end
            
            while(true)
                print("Ending location name: ")
                endingLocation = readline()
               
                try
                    buildingDict[endingLocation]
                    break
                catch e
                    suggestor(endingLocation, buildingDict)
                    continue
                end
            end

            println("Starting location:", startingLocation)
            println("Ending location:", endingLocation)
            # Shortest route function call
        end
    elseif(userInput == "2")
        println("Agent simulation")
    else
        return
    end
end