# Creating agent
# Car <: AbstractAgent
@agent Car OSMAgent begin
end

# Initialize Agent Based Model
function initialise(; map_path = niu)
    # Creating model
    model = ABM(Car, OpenStreetMapSpace(map_path))
    
    startNode = rand(model.space.m.n)
    startLLA = latlon(model.space.m, model.space.m.v[startNode])    
    finishNode = rand(model.space.m.n)
    finishLLA = latlon(model.space.m, model.space.m.v[finishNode])

    # Gathering two locations on the map
    start = osm_intersection((startLLA[1], startLLA[2]), model)
    finish = osm_intersection((finishLLA[1], finishLLA[2]), model)
    
    # Planning route for Car
    route = osm_plan_route(start, finish, model)
    
    # Creating a car that travels from start and ends at finish
    car = add_agent!(start, model, route, finish)
    
    return model, startNode, finishNode
end

# Agent-Steeping function that acts on agent
function agent_step!(agent, model)
    # Car will progress 25 meters along its route
    Agents.move_agent!(agent, model, 10)
end

# Function that provides plotting details of a Car
ac(agent) = :black
as(agent) = 6 

# Function to plot agent
function plotCar(model)
    # Get unique id of each Car
    ids = model.scheduler(model)
    # List of Car color
    colors = [ac(model[i]) for i in ids] 
    # List of Car size
    sizes = [as(model[i]) for i in ids] # Agent size
    markers = :circle
    pos = [osm_map_coordinates(model[i], model) for i in ids]

    global p = OpenStreetMapXPlot.plotmap(model.space.m, width=1000, height=800)

    scatter!(
        pos;
        markercolor = colors,
        markersize = sizes,
        markershapes = markers,
        label = "",
        markerstrokewidth = 0.5,
        markerstrokecolor = :black,
        markeralpha = 0.7,
    )

    
    
end

# # Function to plot shortest route
# function plotShortestRoute(model, startNode, finishNode)
#     p = plotmap(model.space.m, width=600, height=600)
#     shortestRoute = shortest_route(model.space.m, startNode, finishNode)[1]
#     addroute!(p, model.space.m, shortestRoute; route_color="red")
   
#     return p
# end

"""
Prepares car for it's journey
"""
function initialiseCar(startLLA::Tuple{String, String}, endLLA::Tuple{String, String}, model::ABM{<:OpenStreetMapSpace})
    # Gathering two locations on the map
    start = osm_intersection((parse(Float64, startLLA[1]), parse(Float64, startLLA[2])), model)
    finish = osm_intersection((parse(Float64, endLLA[1]), parse(Float64, endLLA[2])), model)

    route = osm_plan_route(start, finish, model)

    car = add_agent!(start, model, route, finish)
end

function moveCar(agent, model)
    move_agent!(agent, model, 10)
end

# Function that provides plotting details of a Car
ac(agent) = :black
as(agent) = 6 

# function plotCar(model)
#      # Get unique id of each Car
#      ids = model.scheduler(model)
#      # List of Car color
#      colors = [ac(model[i]) for i in ids] 
#      # List of Car size
#      sizes = [as(model[i]) for i in ids] # Agent size
#      markers = :circle
#      pos = [osm_map_coordinates(model[i], model) for i in ids]
 
#      scatter!(
#          pos;
#          markercolor = colors,
#          markersize = sizes,
#          markershapes = markers,
#          label = "",
#          markerstrokewidth = 0.5,
#          markerstrokecolor = :black,
#          markeralpha = 0.7,
#      ) 
# end