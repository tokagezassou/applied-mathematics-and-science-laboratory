using Random
using Statistics

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

    shuffle!(all_possible_edges)

    selected_edges = []
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

    if !has_path(graph, start, goal)
        graph = generate_graph(vertex_num, edge_num, start, goal)
    end
    
    return graph
end

function has_path(graph, start, goal)
    visited = fill(false, length(graph))
    queue = [start]
    visited[start] = true

    while !isempty(queue)
        u = popfirst!(queue)
        if u == goal
            return true
        end
        
        for edge in graph[u]
            v = edge.to
            if !visited[v]
                visited[v] = true
                push!(queue, v)
            end
        end
    end

    return false
end

function find_shortest_path(graph, weight, path, vertex, start, goal, best_path, min_weight, node_count)
    node_count += 1
    push!(path, vertex)

    if is_bounded(graph, path, weight, min_weight)
        pop!(path)
        return best_path, min_weight, node_count
    end

    if vertex == goal
        if weight < min_weight
            best_path = copy(path)
            min_weight = weight
        end
        return best_path, min_weight, node_count
    end

    for edge in graph[vertex]
        v = edge.to
        w = edge.weight
        
        if v in path
            continue
        end

        best_path, min_weight, node_count = find_shortest_path(
            graph,
            weight + w,
            path,
            v,
            start,
            goal,
            best_path,
            min_weight,
            node_count,
        )
    end

    pop!(path)
    return best_path, min_weight, node_count
end

function is_bounded(graph, path, current_weight, min_weight)
    lower_bound = current_weight
    
    for u in 1:length(graph)
        if !(u in path) || u == path[end]
            for edge in graph[u]
                if edge.weight < 0
                    lower_bound += edge.weight
                end
            end
        end
    end
    
    return lower_bound >= min_weight
end

function main()
    open("output.dat", "w") do f
        calclate_num = 5
        start = 1
        goal = 2
        vertex_nums = [5, 7, 9, 11, 13, 15]
        ratios = [0.3, 0.5, 0.7, 0.9]

        println(f, "#vertex_num  edge_num  adv_time_ms  std_time_ms  adv_node  std_node")

        for vn in 1:length(vertex_nums)
            for en in 1:length(ratios)
                vertex_num = vertex_nums[vn]
                edge_num = floor(Int, vertex_num * (vertex_num-1) * ratios[en])

                calculate_times_ms = []
                node_nums = []

                for i in 1:calclate_num
                    graph = generate_graph(vertex_num, edge_num, start, goal)

                    start_time = time_ns()
                    _, _, node_count = find_shortest_path(
                        graph,
                        0, #weight
                        [], #path
                        start, #vertex
                        start,
                        goal,
                        [], #best_path
                        Inf, #min_weight,
                        0 #node_count
                    )
                    finish_time = time_ns()

                    time = (finish_time - start_time) / 1000000.0
                    push!(calculate_times_ms, time)
                    push!(node_nums, node_count)

                    if (vn, en) == (length(vertex_nums), length(ratios))
                        println("attempt $i finished")
                    end
                end

                avg_time = mean(calculate_times_ms)
                std_time = std(calculate_times_ms)
                avg_node = mean(node_nums)
                std_node = std(node_nums)
                println(f, "$vertex_num  $edge_num  $avg_time  $std_time  $avg_node  $std_node")

                println("$vertex_num, $edge_num")
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end