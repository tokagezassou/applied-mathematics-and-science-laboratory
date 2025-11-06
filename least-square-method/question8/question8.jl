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

function calculate_estimates_and_variance(vector_x, vector_y)
    data_num = length(vector_x)
    
    sum_phi_T_phi = zeros(3, 3)
    sum_phi_T_y = zeros(3)

    for i in 1:data_num
        x_i = vector_x[i]
        y_i = vector_y[i]

        phi_i = [1.0 exp(-(x_i - 1.0)^2 / 2.0) exp(-(x_i + 1.0)^2)]
        phi_i_T = transpose(phi_i)

        sum_phi_T_phi += phi_i_T * phi_i
        sum_phi_T_y += phi_i_T * y_i
    end

    Phi_N_inv = sum_phi_T_phi

    Phi_N = inv(Phi_N_inv)
    theta_hat = Phi_N * sum_phi_T_y

    sum_sq_residuals = 0.0
    for i in 1:data_num
        x_i = vector_x[i]
        y_i = vector_y[i]
        
        phi_i = [1.0 exp(-(x_i - 1.0)^2 / 2.0) exp(-(x_i + 1.0)^2)]

        y_hat_i = dot(phi_i, theta_hat)
        
        residual = y_i - y_hat_i
        sum_sq_residuals += residual^2
    end

    variance_estimate = sum_sq_residuals / (data_num - 3)

    return theta_hat, Phi_N_inv, sum_phi_T_y, variance_estimate
end

function calculate_weighted_mean(vector_y, weight_1, weight_2)
    sum_w_y = 0.0
    sum_w = 0.0
    data_num = length(vector_y)

    for i in 1:data_num
        y_i = vector_y[i]
        if i <= 6000
            sum_w_y += weight_1 * y_i
            sum_w += weight_1
        else
            sum_w_y += weight_2 * y_i
            sum_w += weight_2
        end
    end
    
    # ゼロ除算を避ける
    if sum_w == 0
        return 0.0
    end
    return sum_w_y / sum_w
end

# 式(3.13)の決定変数に重みを付与したものを計算する
function calculate_weighted_determination_coefficient(
    vector_x, 
    vector_y, 
    theta_hat_estimate, 
    weight_1, 
    weight_2
)
    data_num = length(vector_x)

    sum_w_y = 0.0
    sum_w = 0.0
    data_num = length(vector_y)

    for i in 1:data_num
        y_i = vector_y[i]
        if i <= 6000
            sum_w_y += weight_1 * y_i
            sum_w += weight_1
        else
            sum_w_y += weight_2 * y_i
            sum_w += weight_2
        end
    end
    mean_y = sum_w_y / sum_w
    
    numerator = 0.0 
    denominator = 0.0 

    for i in 1:data_num
        x_i = vector_x[i]
        y_i = vector_y[i]
        
        phi_i = [1.0 exp(-(x_i - 1.0)^2 / 2.0) exp(-(x_i + 1.0)^2)]
        y_hat_i = dot(phi_i, theta_hat_estimate)
        
        residual_sq_regression = (y_hat_i - mean_y)^2
        residual_sq_total = (y_i - mean_y)^2

        if i <= 6000
            numerator += weight_1 * residual_sq_regression
            denominator += weight_1 * residual_sq_total
        else
            numerator += weight_2 * residual_sq_regression
            denominator += weight_2 * residual_sq_total
        end
    end

    weighted_determination_coefficient = numerator / denominator
    return weighted_determination_coefficient
end

const CSV_FILE = "input.csv"

function main()
    open("output.dat", "w") do f
        vector_x, vector_y, has_err = read_csv(CSV_FILE)
        if has_err
            return
        end

        x_1 = vector_x[1:6000]
        y_1 = vector_y[1:6000]
        x_2 = vector_x[6001:10000]
        y_2 = vector_y[6001:10000]
 
        start_time_synth = time_ns()
        println(f, "----- first 6000 data -----")
        theta_hat_1, Phi_N_inv_1, sum_phi_T_y_1, var_1 = calculate_estimates_and_variance(x_1, y_1)
        println(f, "$theta_hat_1  $var_1")

        println(f, "----- last 4000 data -----")
        theta_hat_2, Phi_N_inv_2, sum_phi_T_y_2, var_2 = calculate_estimates_and_variance(x_2, y_2)
        println(f, "$theta_hat_2  $var_2")

        weight_1 = 1.0 / var_1
        weight_2 = 1.0 / var_2
        
        Phi_inv_weighted_1 = weight_1 * Phi_N_inv_1
        Phi_inv_weighted_2 = weight_2 * Phi_N_inv_2
        
        sum_y_weighted_1 = weight_1 * sum_phi_T_y_1
        sum_y_weighted_2 = weight_2 * sum_phi_T_y_2

        Phi_synthesized_inv_weighted = Phi_inv_weighted_1 + Phi_inv_weighted_2
        
        sum_phi_T_y_synthesized_weighted = sum_y_weighted_1 + sum_y_weighted_2
        
        theta_hat_synthesized_weighted = inv(Phi_synthesized_inv_weighted) * sum_phi_T_y_synthesized_weighted
        
        end_time_synth = time_ns()
        calc_time_synth_ns = end_time_synth - start_time_synth

        determination_coefficient = calculate_weighted_determination_coefficient(
            vector_x,
            vector_y,
            theta_hat_synthesized_weighted,
            weight_1,
            weight_2,
        )

        println(f, "----- synthesized (weighted) -----")
        println(f, "$theta_hat_synthesized_weighted  $determination_coefficient  $calc_time_synth_ns")

        println(f, "----- full data (standard) -----")
        start_time_full = time_ns()

        theta_hat_full, _, _, var = calculate_estimates_and_variance(vector_x, vector_y)

        end_time_full = time_ns()
        calc_time_full_ns = end_time_full - start_time_full

        weight = 1 / var
        determination_coefficient = calculate_weighted_determination_coefficient(
            vector_x,
            vector_y,
            theta_hat_full,
            weight,
            weight,
        )

        println(f, "$theta_hat_full  $determination_coefficient  $calc_time_full_ns")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end