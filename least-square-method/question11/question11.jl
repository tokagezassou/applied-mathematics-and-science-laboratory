using CSV
using DataFrames
using LinearAlgebra
using Statistics
using Distributions

function generate_data()
    size = 100
    vector_y = zeros(size)
    vector_theta_true = zeros(size)
    theta_true_prev = rand(Normal(3.0, sqrt(2.0)))
    
    for k in 1:size
        v_k = randn()
        w_k = randn()
        
        theta_true_k = 0.9 * theta_true_prev + v_k
        y_k = 2.0 * theta_true_k + w_k
        
        vector_y[k] = y_k
        vector_theta_true[k] = theta_true_k

        theta_true_prev = theta_true_k
    end
    return vector_theta_true, vector_y
end

function run_kalman_filter(vector_y)
    size = 100
    vector_theta_hat = zeros(size)
    a = 0.9
    c = 2.0
    sigma_v_sq = 1.0
    sigma_w_sq = 1.0
    
    theta_hat_prev = 3.0 # theta_0の平均値
    V_prev = 2.0 # theta_0の分散

    for k in 1:size
        y_k = vector_y[k]
        
        X_k = a^2 * V_prev + sigma_v_sq
        F_k = (c * X_k) / (c^2 * X_k + sigma_w_sq)
        theta_hat_k = a * theta_hat_prev + F_k * (y_k - c * a * theta_hat_prev)
        V_k = (1.0 - F_k * c) * X_k
        
        vector_theta_hat[k] = theta_hat_k
        
        theta_hat_prev = theta_hat_k
        V_prev = V_k
    end
    
    return vector_theta_hat
end

function main()
    open("output.dat", "w") do f
        vector_theta_true, vector_y = generate_data()
        vector_theta_hat = run_kalman_filter(vector_y)
        
        println(f, "# k  theta_hat  theta_true")
        for k in 1:100
            println(f, "$k  $(vector_theta_hat[k])  $(vector_theta_true[k])")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end