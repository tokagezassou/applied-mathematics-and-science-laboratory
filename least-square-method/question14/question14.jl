using CSV
using DataFrames
using LinearAlgebra
using Statistics
using Random
using StatsBase

function read_csv(csv_file_path)
    if !isfile(csv_file_path)
        println("file not found: $csv_file_path")
        return nothing, nothing, true
    end
    df = CSV.read(csv_file_path, DataFrame, header=false)
    
    vector_x1 = df[:, 1]
    vector_x2 = df[:, 2]

    return vector_x1, vector_x2, false
end

function update_assignments(data_X, centers)
    assignments = zeros(Int, 1000)
    
    for i in 1:1000
        point_i = data_X[i, :]
        min_dist_sq = Inf
        best_cluster = 1
        
        for k in 1:3
            dist_sq = norm(point_i - centers[k, :])^2
            if dist_sq < min_dist_sq
                min_dist_sq = dist_sq
                best_cluster = k
            end
        end
        assignments[i] = best_cluster
    end
    
    return assignments
end

function update_centers(data_X, assignments)
    data_N, data_D = size(data_X)
    new_centers = zeros(Float64, 3, data_D)
    cluster_counts = zeros(Int, 3)
    
    for i in 1:data_N
        l = assignments[i]
        new_centers[l, :] .+= data_X[i, :]
        cluster_counts[l] += 1
    end
    
    for k in 1:3
        if cluster_counts[k] > 0
            new_centers[k, :] ./= cluster_counts[k]
        else
            new_centers[k, :] = data_X[rand(1:data_N), :]
        end
    end
    
    return new_centers
end

function calculate_cost(data_X, centers, assignments)
    total_cost = 0.0
    
    for i in 1:1000
        l = assignments[i]
        total_cost += norm(data_X[i, :] - centers[l, :])^2
    end
    
    return total_cost
end

const CSV_FILE = "input.csv" 
const MAX_ITERATIONS = 1000

function main()
    open("output.dat", "w") do f
        vector_x1, vector_x2, has_err = read_csv(CSV_FILE)
        if has_err
            println(f, "failed to read $CSV_FILE")
            return
        end
        
        data_X = hcat(vector_x1, vector_x2)
        data_N = size(data_X, 1)

        best_cost = Inf
        best_centers = nothing
        best_assignments = nothing

        for k in 1:30
            initial_indices = sample(1:data_N, 3, replace=false)
            centers_j = data_X[initial_indices, :]
            
            for j in 1:MAX_ITERATIONS
                centers_prev = deepcopy(centers_j)
                assignments_j = update_assignments(data_X, centers_prev)
                centers_j = update_centers(data_X, assignments_j)
                
                max_diff_sq = maximum(norm(centers_j[l, :] - centers_prev[l, :])^2 for l in 1:3)
                
                if max_diff_sq < 1.0e-9
                    cost = calculate_cost(data_X, centers_j, assignments_j)
                    if cost < best_cost
                        best_cost = cost
                        best_centers = centers_j
                        best_assignments = assignments_j
                    end
                    println(f, "cost = $cost")
                    break
                end
                if j == MAX_ITERATIONS
                    println(f, "not finished within $MAX_ITERATIONS times")
                end
            end
        end

        println(f, "best_cost = $best_cost")
        println(f, "best_centers = $best_centers")
        println(f, "----------------------------------------------------")

        for k in 1:3
            for i in 1:data_N
                if best_assignments[i] == k
                    println(f, "$(vector_x1[i])  $(vector_x2[i])  $(best_assignments[i])")
                end
            end
            println(f, "----------------------------------------------------")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end