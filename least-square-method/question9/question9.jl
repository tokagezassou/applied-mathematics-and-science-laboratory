using CSV
using DataFrames
using LinearAlgebra
using Statistics

# 課題9.1
function estimate_parameters_with_constant_force(dt) 
    M_true = 2.0
    D_true = 1.0
    K_true = 3.0
    epsilon = 1.0e-6

    theta_true = from_MDK_to_theta(M_true, D_true, K_true, dt)
     
    theta_hat = zeros(3)
    Phi_tilde = (1.0 / epsilon) * Matrix(I, 3, 3)

    y_km2 = 0.0
    y_km1 = 0.0
    
    F_km2 = 1.0

    for k in 1:10000
        w_k = rand() * 2.0 - 1.0 
        
        y_k = theta_true[1] * y_km1 + theta_true[2] * y_km2 + theta_true[3] * F_km2 + w_k

        phi_k = [y_km1 y_km2 F_km2] 
        phi_k_T = transpose(phi_k)
        
        denominator = 1.0 + (phi_k * Phi_tilde * phi_k_T)[1]
        K_k = (Phi_tilde * phi_k_T) / denominator
 
        prediction_error = y_k - (phi_k * theta_hat)[1]
        theta_hat = theta_hat + K_k * prediction_error
        Phi_tilde = Phi_tilde - K_k * phi_k * Phi_tilde

        y_km2 = y_km1
        y_km1 = y_k
    end

    return theta_hat
end

# 課題9.2
function estimate_parameters_with_sin_force(dt) 
    M_true = 2.0
    D_true = 1.0
    K_true = 3.0
    epsilon = 1.0e-6

    theta_true = from_MDK_to_theta(M_true, D_true, K_true, dt)
     
    theta_hat = zeros(3)
    Phi_tilde = (1.0 / epsilon) * Matrix(I, 3, 3)

    y_km2 = 0.0
    y_km1 = 0.0

    for k in 1:10000
        w_k = rand() * 2.0 - 1.0
        F_km2 = sin((k-2) * pi / 5)
        
        y_k = theta_true[1] * y_km1 + theta_true[2] * y_km2 + theta_true[3] * F_km2 + w_k

        phi_k = [y_km1 y_km2 F_km2] 
        phi_k_T = transpose(phi_k)
        
        denominator = 1.0 + (phi_k * Phi_tilde * phi_k_T)[1]
        K_k = (Phi_tilde * phi_k_T) / denominator
 
        prediction_error = y_k - (phi_k * theta_hat)[1]
        theta_hat = theta_hat + K_k * prediction_error
        Phi_tilde = Phi_tilde - K_k * phi_k * Phi_tilde

        y_km2 = y_km1
        y_km1 = y_k
    end

    return theta_hat
end

# 課題9.3
function estimate_parameters_with_huge_force(dt) 
    M_true = 2.0
    D_true = 1.0
    K_true = 3.0
    epsilon = 1.0e-6

    theta_true = from_MDK_to_theta(M_true, D_true, K_true, dt)
     
    theta_hat = zeros(3)
    Phi_tilde = (1.0 / epsilon) * Matrix(I, 3, 3)

    y_km2 = 0.0
    y_km1 = 0.0

    for k in 1:10000
        w_k = rand() * 2.0 - 1.0
        F_km2 = 1.0e6
        
        y_k = theta_true[1] * y_km1 + theta_true[2] * y_km2 + theta_true[3] * F_km2 + w_k

        phi_k = [y_km1 y_km2 F_km2]
        phi_k_T = transpose(phi_k)
        
        denominator = 1.0 + (phi_k * Phi_tilde * phi_k_T)[1]
        K_k = (Phi_tilde * phi_k_T) / denominator
 
        prediction_error = y_k - (phi_k * theta_hat)[1]
        theta_hat = theta_hat + K_k * prediction_error
        Phi_tilde = Phi_tilde - K_k * phi_k * Phi_tilde

        y_km2 = y_km1
        y_km1 = y_k
    end

    return theta_hat
end

# 課題9.3
function estimate_parameters_with_random_force(dt) 
    M_true = 2.0
    D_true = 1.0
    K_true = 3.0
    epsilon = 1.0e-6

    theta_true = from_MDK_to_theta(M_true, D_true, K_true, dt)
     
    theta_hat = zeros(3)
    Phi_tilde = (1.0 / epsilon) * Matrix(I, 3, 3)

    y_km2 = 0.0
    y_km1 = 0.0

    for k in 1:10000
        w_k = rand() * 2.0 - 1.0
        F_km2 = 500 * sin((k-2) *  1.7)
        
        y_k = theta_true[1] * y_km1 + theta_true[2] * y_km2 + theta_true[3] * F_km2 + w_k

        phi_k = [y_km1 y_km2 F_km2]
        phi_k_T = transpose(phi_k)
        
        denominator = 1.0 + (phi_k * Phi_tilde * phi_k_T)[1]
        K_k = (Phi_tilde * phi_k_T) / denominator
 
        prediction_error = y_k - (phi_k * theta_hat)[1]
        theta_hat = theta_hat + K_k * prediction_error
        Phi_tilde = Phi_tilde - K_k * phi_k * Phi_tilde

        y_km2 = y_km1
        y_km1 = y_k
    end

    return theta_hat
end

function from_MDK_to_theta(M, D, K, dt)
    theta1 = 2.0 - (D / M) * dt
    theta2 = -(1.0 - (D / M) * dt + (K / M) * dt^2)
    theta3 = (dt^2) / M
    return [theta1, theta2, theta3]
end

function from_theta_to_MDK(theta, dt)
    M = (dt^2) / theta[3]
    D = (2.0 - theta[1]) * M / dt
    K = (1.0 - theta[1] - theta[2]) * M / (dt^2)
    return M, D, K
end

function main()
    open("output.dat", "w") do f
        dt = 0.01

        println(f, "----- constant_force -----")
        theta_hat = estimate_parameters_with_constant_force(dt)
        M_est, D_est, K_est = from_theta_to_MDK(theta_hat, dt)
        println(f, "theta_hat = $theta_hat")
        println(f, "MDK = $M_est  $D_est  $K_est")

        println(f, "----- sin_force -----")
        theta_hat = estimate_parameters_with_sin_force(dt)
        M_est, D_est, K_est = from_theta_to_MDK(theta_hat, dt)
        println(f, "theta_hat = $theta_hat")
        println(f, "MDK = $M_est  $D_est  $K_est")

        println(f, "----- huge_force -----")
        theta_hat = estimate_parameters_with_huge_force(dt)
        M_est, D_est, K_est = from_theta_to_MDK(theta_hat, dt)
        println(f, "theta_hat = $theta_hat")
        println(f, "MDK = $M_est  $D_est  $K_est")

        println(f, "----- random_force -----")
        theta_hat = estimate_parameters_with_random_force(dt)
        M_est, D_est, K_est = from_theta_to_MDK(theta_hat, dt)
        println(f, "theta_hat = $theta_hat")
        println(f, "MDK = $M_est  $D_est  $K_est")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end