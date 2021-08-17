"""
Function that prints locations that beging with the same letter as the 
user inputted location. Eventually I want to implement a Neural Network for suggestions. 

Returns Y or N based on if the user wants to try to submit a location again. 
"""
function locationSuggestor(location::String, buildingDict::Dict{String,Building})
    locationNameArray = []
    userInput = ""
    println("The location ", location, " does not exist")
    println("Here are some recommendations")

    # Print locations that start with the same letter as the user input
    for (key, value) in buildingDict
        if (uppercase(key[1]) == uppercase(location[1]))
            push!(locationNameArray, key)
        end
    end

    sort!(locationNameArray)

    for i in locationNameArray
        println(i)
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