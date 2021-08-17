
"""
Plots a route to the map. Gets nodes closes to the lattitude and longitude passed in. 
"""
function plotShortestRoute(startLLA::Tuple{String, String}, endLLA::Tuple{String, String}, p::Plots.Plot{Plots.GRBackend}, model::ABM{<:OpenStreetMapSpace})
    pointA = point_to_nodes((parse(Float64, startLLA[1]), parse(Float64, startLLA[2])), model.space.m)
    pointB = point_to_nodes((parse(Float64, endLLA[1]), parse(Float64, endLLA[2])), model.space.m)

    shortestRoute = shortest_route(model.space.m, pointA, pointB)[1]
    addroute!(p, model.space.m, shortestRoute; route_color="red")
end

"""
Plots the agent. 
"""
function plotCar(model)
    # Get unique ids of each Car
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

"""
Styling functions for agent.
"""
ac(agent) = :black
as(agent) = 6 