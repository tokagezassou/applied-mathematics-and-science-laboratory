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

    filter_theta_hat = zeros(size + 1)
    filter_V = zeros(size + 1)
    predict_X = zeros(size + 1)

    filter_theta_hat[1] = theta_hat_prev
    filter_V[1] = V_prev

    for k in 1:size
        y_k = vector_y[k]
        
        X_k = a^2 * V_prev + sigma_v_sq
        F_k = (c * X_k) / (c^2 * X_k + sigma_w_sq)
        theta_hat_k = a * theta_hat_prev + F_k * (y_k - c * a * theta_hat_prev)
        V_k = (1.0 - F_k * c) * X_k
        
        vector_theta_hat[k] = theta_hat_k

        predict_X[k+1] = X_k
        filter_theta_hat[k+1] = theta_hat_k
        filter_V[k+1] = V_k
        
        theta_hat_prev = theta_hat_k
        V_prev = V_k
    end
    
    return filter_theta_hat, filter_V, predict_X
end

function run_kalman_smoother(filter_theta_hat, filter_V, predict_X)
    size = 100
    a = 0.9
    
    smooth_theta_hat = zeros(size + 1)
    smooth_V = zeros(size + 1)

    smooth_theta_hat[size+1] = filter_theta_hat[size+1]
    smooth_V[size+1] = filter_V[size+1]

    for k in (size):-1:1
        V_k = filter_V[k]
        X_k_plus_1 = predict_X[k+1]
        theta_hat_k = filter_theta_hat[k]

        theta_hat_k_plus_1_s = smooth_theta_hat[k+1]
        V_k_plus_1_s = smooth_V[k+1]

        g_k = a * V_k / X_k_plus_1
        
        smooth_theta_hat[k] = theta_hat_k + g_k * (theta_hat_k_plus_1_s - a * theta_hat_k)
        smooth_V[k] = V_k + g_k^2 * (V_k_plus_1_s - X_k_plus_1)
    end
    
    return smooth_theta_hat, smooth_V
end

function main()
    open("output.dat", "w") do f
        vector_theta_true, vector_y = generate_data()
        filter_theta_hat, filter_V, predict_X = run_kalman_filter(vector_y)
        smooth_theta_hat, smooth_V = run_kalman_smoother(filter_theta_hat, filter_V, predict_X)

        theta_0_hat_smooth = smooth_theta_hat[1]
        V_0_smooth = smooth_V[1]
        V_0_initial = filter_V[1]
        ratio = V_0_smooth / V_0_initial
        
        println(f, "theta_0_hat_smooth = $theta_0_hat_smooth")
        println(f, "V_0_smooth = $V_0_smooth")
        println(f, "V_0_initial = $V_0_initial")
        println(f, "ratio = $ratio")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end