using CSV
using DataFrames
using LinearAlgebra
using Statistics

# 課題9.1
function estimate_parameters_with_constant_force() 
    M_true = 2.0
    D_true = 1.0
    K_true = 3.0
    dt = 0.01
    epsilon = 1.0e-6

    theta1_true = 2.0 - (D_true / M_true) * dt
    theta2_true = -(1.0 - (D_true / M_true) * dt + (K_true / M_true) * dt^2)
    theta3_true = (dt^2) / M_true
     
    theta_hat = zeros(3)
    Phi_tilde = (1.0 / epsilon) * Matrix(I, 3, 3) 

    y_k-2 = 0.0 
    y_k-1 = 0.0 
    
    F_k-2 = 1.0 
    F_k-1 = 1.0
    F_k = 1.0         

    theta_history = zeros(10000, 3)

    for k in 1:10000
        w_k = rand() * 2.0 - 1.0 
        
        y_k = theta1_true * y_k-1 + theta2_true * y_k-2 + theta3_true * F_k-2 + w_k

        phi_k = [y_-1 y_-2 F_-2] 
        phi_k_T = transpose(phi_k)
        
        denominator = 1.0 + (phi_k * Phi_tilde * phi_k_T)[1]
        K_k = (Phi_tilde * phi_k_T) / denominator
 
        prediction_error = y_k - (phi_k * theta_hat)[1]
        theta_hat = theta_hat + K_k * prediction_error
        Phi_tilde = Phi_tilde - K_k * phi_k * Phi_tilde

        theta_history[k, :] = theta_hat

        y_k-2 = y_k-1
        y_k-1 = y_k 
        F_k-2 = F_k-1
        F_k-1 = F_k
    end

    return theta_hat
end

function from_theta_hat_to_MDK(theta_hat)
    M = (DT^2) / theta_hat[3]
    D = (2.0 - theta_hat[1]) * M_est / DT
    K = (1.0 - theta_hat[1] - theta_hat[2]) * M_est / (DT^2)

    return M, D, K
end

function main()
    open("output.dat", "w") do f
        theta_hat = estimate_parameters_with_constant_force()
        M_est, D_est, K_est = from_theta_hat_to_MDK(theta_hat)
        print(f, M_est, D_est,K_est)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end