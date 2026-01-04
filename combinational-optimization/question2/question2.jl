struct Edge
    to::Int
    weight::Float64
end

function generate_graph(vertex_num, edge_num, start, goal)
    all_possible_edges = []
    for u in 1:vertex_num
        for v in 1:vertex_num
            if u != v
                push!(all_possible_edges, (u, v))
            end
        end
    end
    filter!(e -> e != (start, goal), all_possible_edges)

    shuffle!(all_possible_edges)

    selected_edges = [(start, goal)]
    for (u, v) in all_possible_edges
        if length(selected_edges) >= edge_num
            break
        end
        push!(selected_edges, (u, v))
    end

    graph = [Edge[] for _ in 1:vertex_num]
    for (u, v) in selected_edges
        weight = rand() * 120.0 - 20.0 
        push!(graph[u], Edge(v, weight))
    end
    
    return graph
end

function find_shortest_path(graph, weight, path, vertex, start, goal, best_path, min_weight)
    push!(path, vertex)
    if vertex == goal
        if weight < min_weight
            best_path = path
            min_weight = weight
        end
        return best_path, min_weight
    end

    children = []
    for i in 1:length(graph[vertex])
        push!(children, (graph[vertex].to, graph[vertex].weight))
    end

    for (v, w) in children
        best_path, min_weight = find_shortest_path(
            graph,
            weight + w,
            path,
            v,
            start,
            goal,
            best_path,
            min_weight
        )
    end
end

function main()
    open("output.dat", "w") do f
        
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end