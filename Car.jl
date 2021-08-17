 """ Car <: AbstractAgent """
@agent Car OSMAgent begin
end

"""
Agent-Steeping function that acts on agent
"""
function agent_step!(agent, model)
    # Car will progress 25 meters along its route
    Agents.move_agent!(agent, model, 10)
end

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

"""
Function that moves an agent.
"""
function moveCar(agent, model)
    move_agent!(agent, model, 10)
end
