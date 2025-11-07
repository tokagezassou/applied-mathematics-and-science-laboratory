using CSV
using DataFrames
using LinearAlgebra
using Statistics

function read_csv(csv_file_path)
    if !isfile(csv_file_path)
        println("file not found: $csv_file_path")
        return nothing, nothing, true
    end
    df = CSV.read(csv_file_path, DataFrame, header=false)
    vector_x = df[:, 1]
    vector_y = df[:, 2]

    return vector_x, vector_y, false
end

function form_phi(x_i)
    return [1.0 x_i x_i^2;
        x_i x_i^2 x_i^3]
end

function fix_beta_solve_alpha(vector_x, vector_y, beta_hat)
    data_num = length(vector_x)
    
    sum_psi_psi_T = zeros(2, 2)
    sum_psi_y = zeros(2)

    for i in 1:data_num
        x_i = vector_x[i]
        y_i = vector_y[i]
        
        phi_i = form_phi(x_i)
        psi_i = phi_i * beta_hat
        
        sum_psi_psi_T += psi_i * transpose(psi_i)
        sum_psi_y += psi_i * y_i
    end
    
    epsilon = 1e-8
    alpha_hat = inv(sum_psi_psi_T + epsilon * I) * sum_psi_y
    
    return alpha_hat
end

function fix_alpha_solve_beta(vector_x, vector_y, alpha_hat)
    data_num = length(vector_x)
    
    sum_rho_rho_T = zeros(3, 3)
    sum_rho_y = zeros(3)

    for i in 1:data_num
        x_i = vector_x[i]
        y_i = vector_y[i]
        
        phi_i = form_phi(x_i)
        rho_i_T = transpose(alpha_hat) * phi_i
        rho_i = transpose(rho_i_T)
        
        sum_rho_rho_T += rho_i * rho_i_T
        sum_rho_y += rho_i * y_i
    end
    
    epsilon = 1e-8
    beta_hat = inv(sum_rho_rho_T + epsilon * I) * sum_rho_y
    
    return beta_hat
end

function calculate_cost(vector_x, vector_y, alpha_hat, beta_hat)
    data_num = length(vector_x)
    total_cost = 0.0
    
    for i in 1:data_num
        x_i = vector_x[i]
        y_i = vector_y[i]
        
        phi_i = form_phi(x_i)
        y_hat_i = transpose(alpha_hat) * phi_i * beta_hat
        
        residual = y_i - y_hat_i
        total_cost += residual^2
    end
    
    return total_cost
end

const CSV_FILE = "input.csv"
const MAX_ITERATIONS = 1000

function main()
    open("output.dat", "w") do f
        vector_x, vector_y, has_err = read_csv(CSV_FILE)
        if has_err
            println(f, "failed to read $CSV_FILE")
            return
        end

        for k in 1:10
            # alpha_j = rand(2) * 100 .- 50
            # beta_j = rand(3) * 100 .- 50
            alpha_j = rand(2)
            beta_j = rand(3)
            println(f, "alpha_0 = $alpha_j, beta_0 = $beta_j")
            
            for j in 1:MAX_ITERATIONS
                alpha_prev = alpha_j
                beta_prev = beta_j
                
                alpha_j = fix_beta_solve_alpha(vector_x, vector_y, beta_prev)
                beta_j = fix_alpha_solve_beta(vector_x, vector_y, alpha_j)
                
                diff_norm_sq = norm(alpha_j - alpha_prev)^2 + norm(beta_j - beta_prev)^2
                if diff_norm_sq < 1.0e-9
                    cost = calculate_cost(vector_x, vector_y, alpha_j, beta_j)
                    println(f, "cost = $cost $j times to finish")
                    println(f, "--------------------------")
                    break
                end
                if j == MAX_ITERATIONS
                    println(f, "not finished within $MAX_ITERATIONS times")
                end
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end