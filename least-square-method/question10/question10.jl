using CSV
using DataFrames
using LinearAlgebra
using Statistics

function generate_data()
    size = 10000
    vector_y = zeros(size)
    vector_theta_true = zeros(size)
    
    for k in 1:size
        theta_true = sin(0.0001 * k)
        
        w_k = rand([-1.0, 1.0])
        y_k = theta_true + w_k
        
        vector_y[k] = y_k
        vector_theta_true[k] = theta_true
    end
    return vector_y, vector_theta_true
end

function estimate_theta(vector_y)
    N = length(vector_y)
    vector_theta_hat = zeros(N)
    theta_hat = 0.0
    Phi = 1000.0
    gamma = 0.99

    for k in 1:10000
        y_k = vector_y[k]
        
        K = Phi / (gamma + Phi)
        theta_hat = theta_hat + K * (y_k - theta_hat)
        Phi = (1.0 / gamma) * Phi * (1.0 - K)
        
        vector_theta_hat[k] = theta_hat
    end
    
    return vector_theta_hat
end

function main()
    open("output.dat", "w") do f
        vector_y, vector_theta_true = generate_data()
        vector_theta_hat = estimate_theta(vector_y)
        println(f, "# k  theta_hat  theta_true")
        for k in 1:10000
            println(f, "$k  $(vector_theta_hat[k])  $(vector_theta_true[k])")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end